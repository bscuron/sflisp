public class LispInterpreter {

    private static LispEnvironment GLOBAL_ENV = new LispEnvironment(null);
    private LispEnvironment env;

    static {
        GLOBAL_ENV.set(LispSymbol.intern('t'), LispT.INSTANCE);
        GLOBAL_ENV.set(LispSymbol.intern('nil'), LispNil.INSTANCE);

        GLOBAL_ENV.set(LispSymbol.intern('if'), new LispSpecialFormIf());
        GLOBAL_ENV.set(LispSymbol.intern('and'), new LispSpecialFormAnd());
        GLOBAL_ENV.set(LispSymbol.intern('or'), new LispSpecialFormOr());
        GLOBAL_ENV.set(LispSymbol.intern('quote'), new LispSpecialFormQuote());
        GLOBAL_ENV.set(LispSymbol.intern('cond'), new LispSpecialFormCond());
        GLOBAL_ENV.set(LispSymbol.intern('lambda'), new LispSpecialFormLambda());
        GLOBAL_ENV.set(LispSymbol.intern('let'), new LispSpecialFormLet());
        GLOBAL_ENV.set(LispSymbol.intern('let*'), new LispSpecialFormLetStar());
        GLOBAL_ENV.set(LispSymbol.intern('progn'), new LispSpecialFormProgn());
        GLOBAL_ENV.set(LispSymbol.intern('defun'), new LispSpecialFormDefun());
        GLOBAL_ENV.set(LispSymbol.intern('map'), new LispSpecialFormMap());
        GLOBAL_ENV.set(LispSymbol.intern('filter'), new LispSpecialFormFilter());
        GLOBAL_ENV.set(LispSymbol.intern('='), new LispSpecialFormNumericEqual());
        GLOBAL_ENV.set(LispSymbol.intern('/='), new LispSpecialFormNumericNotEqual());
        GLOBAL_ENV.set(LispSymbol.intern('<'), new LispSpecialFormNumericLessThan());
        GLOBAL_ENV.set(LispSymbol.intern('<='), new LispSpecialFormNumericLessThanEqual());
        GLOBAL_ENV.set(LispSymbol.intern('>'), new LispSpecialFormNumericGreaterThan());
        GLOBAL_ENV.set(LispSymbol.intern('>='), new LispSpecialFormNumericGreaterThanEqual());

        GLOBAL_ENV.set(LispSymbol.intern('+'), new LispPrimitiveAdd());
        GLOBAL_ENV.set(LispSymbol.intern('*'), new LispPrimitiveMul());
        GLOBAL_ENV.set(LispSymbol.intern('-'), new LispPrimitiveSub());
        GLOBAL_ENV.set(LispSymbol.intern('/'), new LispPrimitiveDiv());
        GLOBAL_ENV.set(LispSymbol.intern('not'), new LispPrimitiveNot());
        GLOBAL_ENV.set(LispSymbol.intern('cons'), new LispPrimitiveCons());
        GLOBAL_ENV.set(LispSymbol.intern('car'), new LispPrimitiveCar());
        GLOBAL_ENV.set(LispSymbol.intern('cdr'), new LispPrimitiveCdr());
        GLOBAL_ENV.set(LispSymbol.intern('eq'), new LispPrimitiveEq());
        GLOBAL_ENV.set(LispSymbol.intern('eql'), new LispPrimitiveEql());
        GLOBAL_ENV.set(LispSymbol.intern('equal'), new LispPrimitiveEqual());
        GLOBAL_ENV.set(LispSymbol.intern('apply'), new LispPrimitiveApply());
        GLOBAL_ENV.set(LispSymbol.intern('assoc'), new LispPrimitiveAssoc());
        GLOBAL_ENV.set(LispSymbol.intern('rassoc'), new LispPrimitiveRassoc());
        GLOBAL_ENV.set(LispSymbol.intern('iota'), new LispPrimitiveIota());
        GLOBAL_ENV.set(LispSymbol.intern('format'), new LispPrimitiveFormat());
        GLOBAL_ENV.set(LispSymbol.intern('append'), new LispPrimitiveAppend());
        GLOBAL_ENV.set(LispSymbol.intern('null'), new LispPrimitiveNull());
   }

    public LispInterpreter() {
        this.env = new LispEnvironment(GLOBAL_ENV);
    }

    public LispObject eval(String lisp) {
        return eval(lisp, env);
    }

    private static LispObject eval(String lisp, LispEnvironment env) {
        List<LispLexer.Token> tokens = LispLexer.tokenize(lisp);
        List<LispObject> objs = LispParser.parse(tokens);
        LispObject result = LispNil.INSTANCE;
        for (LispObject obj: objs) {
            result = obj.eval(env);
        }
        return result;
    }

}
