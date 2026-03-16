public class LispSpecialFormProgn extends LispSpecialForm {

    public LispSpecialFormProgn() {
        super('(progn &rest BODY)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject result = LispNil.INSTANCE;

        while (!args.isNil()) {
            result = args.car().eval(env);
            args = args.cdr();
        }

        return result;
    }
}
