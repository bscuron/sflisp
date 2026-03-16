public class LispCons extends LispObject {

    private final LispObject car;
    private final LispObject cdr;

    public LispCons(LispObject car, LispObject cdr) {
        this.car = car ?? LispNil.INSTANCE;
        this.cdr = cdr ?? LispNil.INSTANCE;
    }

    public override LispObject car() {
        return car;
    }

    public override LispObject cdr() {
        return cdr;
    }

    public override LispObject eval(LispEnvironment env) {
        LispObject head = car().eval(env);

        if (head instanceof LispCallable) {
            if (head instanceof LispMacro) {
                LispMacro macro = (LispMacro)head;
                LispObject expanded = macro.apply(cdr(), env);
                return expanded.eval(env);
            } else if (head instanceof LispSpecialForm) {
                LispSpecialForm spec = (LispSpecialForm)head;
                LispObject args = cdr();
                spec.validateArguments(args);
                return spec.apply(args, env);
            } else {
                LispCallable callable = (LispCallable)head;
                LispObject args = evalArguments(cdr(), env);
                callable.validateArguments(args);
                return callable.apply(args, env);
            }
        }

        return this;
    }

    private static LispObject evalArguments(LispObject args, LispEnvironment env) {
        if (args.isNil()) {
            return LispNil.INSTANCE;
        }

        if (!(args instanceof LispCons)) {
            return args.eval(env);
        }

        LispObject evaledCar = args.car().eval(env);
        LispObject evaledCdr = evalArguments(args.cdr(), env);
        return new LispCons(evaledCar, evaledCdr);
    }

    public override String toString() {
        String result = '(';
        LispObject current = this;

        Boolean first = true;

        while (current instanceof LispCons) {
            if (!first) {
                result += ' ';
            }

            LispCons cons = (LispCons)current;
            result += cons.car().toString();

            current = cons.cdr();
            first = false;
        }

        if (!current.isNil()) {
            result += ' . ' + current.toString();
        }

        result += ')';
        return result;
    }

}
