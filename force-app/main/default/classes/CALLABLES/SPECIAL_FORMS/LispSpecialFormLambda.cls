public class LispSpecialFormLambda extends LispSpecialForm {

    public LispSpecialFormLambda() {
        super('(lambda ARGS &rest BODY)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject argList = args.car();
        LispObject body = args.cdr();
        System.assert(argList instanceof LispCons || argList.isNil(), 'Lambda parameter list must be a list: ' + argList);
        LispSignature signature = new LispSignature(new LispCons(LispSymbol.intern('lambda'), argList));
        return new LispClosure(signature, body, env);
    }
}
