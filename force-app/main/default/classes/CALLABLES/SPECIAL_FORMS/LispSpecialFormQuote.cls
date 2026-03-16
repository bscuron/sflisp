public class LispSpecialFormQuote extends LispSpecialForm {

    public LispSpecialFormQuote() {
        super('(quote ARG)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        return args.car();
    }
}
