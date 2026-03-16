public class LispSpecialFormDefun extends LispSpecialForm {

    public LispSpecialFormDefun() {
        super('(defun NAME ARGLIST &rest BODY)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispSymbol name = (LispSymbol)args.car();
        LispObject paramList = args.cdar();
        LispObject body = args.cddr();
        env.set(name, LispNil.INSTANCE);
        LispSignature signature = new LispSignature(new LispCons(name, paramList));
        LispClosure fn = new LispClosure(signature, body, env);
        env.set(name, fn);
        return name;
    }

}
