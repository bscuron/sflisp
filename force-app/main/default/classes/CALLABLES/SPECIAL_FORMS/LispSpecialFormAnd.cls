public class LispSpecialFormAnd extends LispSpecialForm {

    public LispSpecialFormAnd() {
        super('(and &rest CONDITIONS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject result = LispT.INSTANCE;

        while (!args.isNil()) {
            result = args.car().eval(env);

            if (result.isNil()) {
                return LispNil.INSTANCE;
            }

            args = args.cdr();
        }

        return result;
    }
}
