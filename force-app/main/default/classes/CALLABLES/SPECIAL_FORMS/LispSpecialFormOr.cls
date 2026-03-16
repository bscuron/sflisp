public class LispSpecialFormOr extends LispSpecialForm {

    public LispSpecialFormOr() {
        super('(or &rest CONDITIONS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        while (!args.isNil()) {
            LispObject result = args.car().eval(env);

            if (!result.isNil()) {
                return result;
            }
            
            args = args.cdr();
        }

        return LispNil.INSTANCE;
    }
}
