public inherited sharing class Interpreter {

	private static List<Map<String, Object>> STACK = new List<Map<String, Object>>();
	private static Map<String, Closure> VTABLE = new Map<String, Closure>();

	private class Closure {
		public List<String> params;
		public Object body;
		public List<Map<String,Object>> capture;

		public Closure(List<String> params, Object body, List<Map<String, Object>> stack) {
			this.params = params;
			this.body = body;
			this.capture = stackCopy(stack);
		}
	}

	public static Object eval(String exp) {
		stackPush();
		return eval((Object)JSON.deserializeUntyped(exp));
	}

	private static Object eval(Object exp) {
			Object result;
			if (exp == null
				|| exp instanceof Integer
				|| exp instanceof Decimal
				|| exp instanceof Closure
			) {
					result = exp;
			} else if (exp instanceof String) {
					String s = (String)exp;
					if (s.startsWith('$')) {
							result = stackFind(s.substring(1), true);
					} else {
							result = s;
					}
			} else if (exp instanceof List<Object>) {
					List<Object> sexp = (List<Object>)exp;
					if (sexp.isEmpty()) {
							result = sexp;
					} else if (sexp[0] instanceof String) {
							String operator = (String)sexp[0];
							List<Object> operands = sexp.clone();
							operands.remove(0);
							result = apply(operator, operands);
					} else {
							result = sexp;
					}
			} else {
					throw new IllegalArgumentException('ERROR: Cannot evaluate expession: `' + exp + '`');
			}

			return result;
	}

	private static List<Object> eval(List<Object> operands) {
		List<Object> arguments = new List<Object>();
		for (Object operand: operands) {
			arguments.add(eval(operand));
		}
		return arguments;
	}

	private static Object apply(Object operator, List<Object> operands) {
		if (operator instanceof String) {
			String name = (String)operator;

			Object closure = stackFind(name, false);
			if (closure instanceof Closure) {
					operator = closure;
			} else if (VTABLE.containsKey(name)) {
					operator = VTABLE.get(name);
			} else {
				switch on name {
					// (if cond then else)
					when 'if' {
						Object ifCond = operands[0];
						Object ifThen = operands[1];
						Object ifElse = operands[2];
						return truthy(eval(ifCond)) ? eval(ifThen) : eval(ifElse);
					}
					// (when cond then)
					when 'when' {
						Object ifCond = operands[0];
						Object ifThen = operands[1];
						return truthy(eval(ifCond)) ? eval(ifThen) : null;
					}
					// (unless cond then)
					when 'unless' {
						Object ifCond = operands[0];
						Object ifThen = operands[1];
						return truthy(eval(ifCond)) ? null : eval(ifThen);
					}
					// (progn body ...)
					when 'progn' {
						Object result = null;
						for (Object operand: operands) {
							result = eval(operand);
						}
						return result;
					}
					// (prog1 first body ...)
					when 'prog1' {
						Object result = eval(operands[0]);
						for (Integer i = 1; i < operands.size(); ++i) {
							eval(operands[i]);
						}
						return result;
					}
					// (lambda parameters body)
					when 'lambda' {
						System.assert(operands[0] instanceof List<Object>, 'ERROR: lambda expects the parameter list as the first operand');
						List<String> parameters = new List<String>();
						for (Object operand: (List<Object>)operands[0]) {
							System.assert(operand instanceof String, 'ERROR: lambda parameters must be strings');
							parameters.add((String)operand);
						}
						return new Closure(parameters, operands[1], STACK);
					}
					// (defun name parameters body)
					when 'defun' {
						System.assert(operands[0] instanceof String, 'ERROR: defun expects the function name as the first operand');
						List<String> parameters = new List<String>();
						for (Object operand: (List<Object>)operands[1]) {
							System.assert(operand instanceof String, 'ERROR: function parameters must be strings');
							parameters.add((String)operand);
						}
						String functionName = (String)operands[0];
						VTABLE.put(functionName, new Closure(parameters, operands[2], STACK));
						return VTABLE.get(functionName);
					}
					// (let [[symbol value]] body)
					when 'let' {
						stackPush();
						System.assert(operands[0] instanceof List<Object>, 'ERROR: let expects the binding list as the first operand');
						for (Object operand: (List<Object>)operands[0]) {
							System.assert(operand instanceof List<Object>, 'ERROR: let expects each element in the binding list to be a list of string-value pairs');
							List<Object> binding = (List<Object>)operand;
							System.assert(binding.size() == 2,  'ERROR: let expects each element in the binding list to be a list of string-value pairs');
							String symbol = (String)binding[0];
							Object value = eval(binding[1]);
							stackBind(symbol, value);
						}

						Object result = null;
						for (Integer i = 1; i < operands.size(); i++) {
							result = eval(operands[i]);
						}

						stackPop();
						return result;
					}
					// (filter pred list)
					when 'filter' {
							List<Object> elements = (List<Object>)operands[1];
							Object fn = operands[0];
							List<Object> results = new List<Object>();

							if (fn instanceof Closure) {
									fn = (Closure)fn;
							} else if (fn instanceof List<Object> && ((List<Object>)fn)[0] == 'lambda') {
									fn = (Closure)eval(fn);
							} else {
									fn = normalizeImplicitClosure(fn, 1);
							}

							for (Object elem : elements) {
									if (truthy(apply(fn, new List<Object>{elem}))) {
											results.add(elem);
									}
							}

							return results;
					}
					// (map function list)
					when 'map' {
							List<Object> elements = (List<Object>)operands[1];
							Object fn = operands[0];
							List<Object> results = new List<Object>();

							if (fn instanceof Closure) {
									fn = (Closure)fn;
							} else if (fn instanceof List<Object> && ((List<Object>)fn)[0] == 'lambda') {
									fn = (Closure)eval(fn);
							} else {
									fn = normalizeImplicitClosure(fn, 1);
							}

							for (Object elem : elements) {
									results.add(apply(fn, new List<Object>{elem}));
							}

							return results;
					}
					// (reduce pred list initial)
					when 'reduce' {
							List<Object> elements = (List<Object>)operands[1];
							Object fn = operands[0];
							Object acc = operands[2];

							if (fn instanceof Closure) {
									fn = (Closure)fn;
							} else if (fn instanceof List<Object> && ((List<Object>)fn)[0] == 'lambda') {
									fn = (Closure)eval(fn);
							} else {
									fn = normalizeImplicitClosure(fn, 2);
							}

							for (Object elem : elements) {
									acc = apply(fn, new List<Object>{acc, elem});
							}

							return acc;
					}
					// (apply function list)
					when 'apply' {
							return apply(operands[0], (List<Object>)operands[1]);
					}
				}
				operands = eval(operands);
				switch on name {
					// TODO: add more builtins
					when '//' { return null; }
					when '+', '-', '*', '/' { return arithmetic(name, operands); }
					when '=', '/=', '<', '>', '<=', '>=' { return equality(name, operands); }
					when 'and', 'or' { return logical(name, operands); }
					when 'concat' { String s=''; for (Object operand: operands) s+=operand; return s; }
					when else {
						throw new IllegalArgumentException('ERROR: Unknown operator: ' + name);
					}
				}
			}
		}
		operands = eval(operands);

		if (operator instanceof Closure) {
				Closure closure = (Closure)operator;
				List<Map<String,Object>> save = STACK;
				STACK = stackCopy(closure.capture);

				stackPush();
				for (Integer i = 0; i < closure.params.size(); i++) {
						stackBind(closure.params[i], operands[i]);
				}

				Object result = eval(closure.body);

				stackPop();
				STACK = save;
				return result;
		}


		throw new IllegalArgumentException('ERROR: Cannot apply non-function: ' + operator);
	}

	private static void stackPush() {
		STACK.add(new Map<String,Object>());
	}

	private static void stackPop() {
		STACK.remove(STACK.size()-1);
	}

	private static void stackBind(String name, Object value) {
		STACK[STACK.size()-1].put(name, value);
	}

	private static Object stackFind(String name, Boolean throwIfNotFound) {
		for (Integer i = STACK.size()-1; i >= 0; i--) {
			if (STACK[i].containsKey(name)) {
				return STACK[i].get(name);
			}
		}
		if (throwIfNotFound) {
			throw new IllegalArgumentException('ERROR: Unbound symbol: ' + name);
		}
		return null;
	}

	private static List<Map<String, Object>> stackCopy(List<Map<String, Object>> stack) {
		List<Map<String, Object>> copy = new List<Map<String, Object>>();
		for (Map<String, Object> frame: stack) {
			copy.add(frame.clone());
		}
		return copy;
	}

	private static Boolean logical(String operator, List<Object> arguments) {
		switch on operator {
			when 'and' {
				Boolean result = true;
				for (Object argument: arguments) {
					result &= truthy(argument);
					if (!result) {
						break;
					}
				}
				return result;
			}
			when 'or' {
				Boolean result = false;
				for (Object argument: arguments) {
					result |= truthy(argument);
					if (result) {
						break;
					}
				}
				return result;
			}
			when else {
				throw new IllegalArgumentException('ERROR: Invalid logical operator: ' + operator);
			}
		}
	}

	private static Object arithmetic(String operator, List<Object> arguments) {
		if (arguments.isEmpty()) {
			throw new IllegalArgumentException('ERROR: `' + operator + '` requires at least one operand');
		}

		Boolean isInteger = true;
		for (Object operand: arguments) {
			if (operand instanceof Integer) {
			} else if (operand instanceof Decimal) {
				isInteger = false;
				break;
			} else {
				throw new IllegalArgumentException('ERROR: Cannot apply arithmetic operator `' + operator + '` to `' + operand + '`');
			}
		}
		Decimal result = (Decimal)arguments[0];

		if (operator == '-' && arguments.size() == 1) {
			return isInteger ? -(Integer)result : -result;
		}

		for (Integer i = 1; i < arguments.size(); i++) {
			Object value = arguments[i];
			Decimal current = (Decimal)arguments[i];

			switch on operator {
				when '+' { result += current; }
				when '-' { result -= current; }
				when '*' { result *= current; }
				when '/' {
					if (current == 0) {
						throw new IllegalArgumentException('ERROR: Division by zero');
					} else {
						result /= current;
						if (isInteger) {
							result = result.round(System.RoundingMode.DOWN);
						}
					}
				}
			}
		}

		return isInteger ? (Integer)result : result;
	}

	private static Boolean equality(String op, List<Object> arguments) {

		if (arguments.size() < 2) return true;

		for (Integer i = 0; i < arguments.size() - 1; i++) {
			Integer c = equality(arguments[i], arguments[i+1]);

			Boolean ok;
			switch on op {
				when '<'  { ok = c < 0; }
				when '>'  { ok = c > 0; }
				when '<=' { ok = c <= 0; }
				when '>=' { ok = c >= 0; }
				when '='  { ok = c == 0; }
				when '/='  { ok = c != 0; }
				when else { throw new IllegalArgumentException('ERROR: Unknown operator: ' + op); }
			}

			if (!ok) return false;
		}

		return true;
	}


	private static Integer equality(Object a, Object b) {
		if (a == null && b == null) {
			return 0;
		}
		if (a != null && b == null) {
			return 1;
		}
		if (a == null && b != null) {
			return -1;
		}
		if (a instanceof Integer && b instanceof Decimal) {
			Decimal aa = Decimal.valueOf((Integer)a);
			Decimal bb = (Decimal)b;
			return equality(aa, bb);
		}
		if (a instanceof Decimal && b instanceof Integer) {
			Decimal aa = (Decimal)a;
			Decimal bb = Decimal.valueOf((Integer)b);
			return equality(aa, bb);
		}
		if (a instanceof Integer && b instanceof Integer) {
			Integer aa = (Integer)a;
			Integer bb = (Integer)b;
			return aa == bb ? 0 : (aa > bb ? 1 : -1);
		}
		if (a instanceof Decimal && b instanceof Decimal) {
			Decimal aa = (Decimal)a;
			Decimal bb = (Decimal)b;
			return aa == bb ? 0 : (aa > bb ? 1 : -1);
		}
		if (a instanceof Boolean && b instanceof Boolean) {
			Boolean aa = (Boolean)a;
			Boolean bb = (Boolean)b;
			return aa == bb ? 0 : (aa ? 1 : -1);
		}
		if (a instanceof Date && b instanceof Date) {
			Date aa = (Date)a;
			Date bb = (Date)b;
			return aa == bb ? 0 : (aa > bb ? 1 : -1);
		}
		if (a instanceof Datetime && b instanceof Datetime) {
			Datetime aa = (Datetime)a;
			Datetime bb = (Datetime)b;
			return aa == bb ? 0 : (aa > bb ? 1 : -1);
		}
		if (a instanceof String && b instanceof String) {
			String aa = (String)a;
			String bb = (String)b;
			return aa == bb ? 0 : (aa > bb ? 1 : -1);
		}
		if (a instanceof SObject && b instanceof SObject) {
			Id aa = ((SObject)a).Id;
			Id bb = ((SObject)b).Id;
			return aa == bb ? 0 : 1;
		}

		throw new IllegalArgumentException('ERROR: Cannot compare `' + a + '` to `' + b + '`');
	}

	private static Boolean truthy(Object exp) {
		if (exp == null) {
			return false;
		}
		if (exp instanceof Boolean) {
			Boolean concrete = (Boolean)exp;
			return concrete;
		}
		if (exp instanceof Integer) {
			Integer concrete = (Integer)exp;
			return concrete != 0;
		}
		if (exp instanceof Decimal) {
			Decimal concrete = (Decimal)exp;
			return concrete != 0;
		}
		if (exp instanceof String) {
			String concrete = (String)exp;
			return !String.isEmpty(concrete);
		}
		if (exp instanceof List<Object>) {
			List<Object> concrete = (List<Object>)exp;
			return !concrete.isEmpty();
		}
		if (exp instanceof Map<String, Object>) {
			Map<String, Object> concrete = (Map<String, Object>)exp;
			return !concrete.isEmpty();
		}
		// TODO: im probably missing some types here
		System.assert(false, 'ERROR: Cannot convert `' + exp + '` to boolean');
		return true;
	}

	private static Boolean isClosure(Object exp) {
		if (exp instanceof List<Object> && ((List<Object>)exp)[0] instanceof String) {
			String name = ((String)((List<Object>)exp)[0]);
			if (name == 'lambda') {
				return true;
			}
			Object closure = stackFind(name.substring(1), false);
			if (closure == null) {
				closure = VTABLE.get(name);
			}
			if (closure instanceof Closure) {
				return true;
			}
		}
		return false;
	}

	private static Closure normalizeImplicitClosure(Object fn, Integer arity) {
			if (fn instanceof Closure) {
					return (Closure)fn;
			} else if (fn instanceof List<Object>) {
					List<String> params = new List<String>();
					for (Integer i = 0; i < arity; i++) {
							params.add(String.fromCharArray(new List<Integer>{97 + i}));
					}
					return new Closure(params, fn, STACK);
			} else if (fn instanceof String && ((String)fn).startsWith('$')) {
					Object resolved = stackFind(((String)fn).substring(1), true);
					return normalizeImplicitClosure(resolved, arity);
			} else {
					throw new IllegalArgumentException('Not a callable: ' + fn);
			}
	}

}
