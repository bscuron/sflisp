public class LispPrimitiveCons extends LispPrimitive {

    public LispPrimitiveCons() {
        super('(cons CAR CDR)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject car = args.car();
        LispObject cdr = args.cdar();
        return new LispCons(car, cdr);
    }
}
