public class LispPrimitiveIota extends LispPrimitive {

    public LispPrimitiveIota() {
        super('(iota COUNT &optional START STEP)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject countObj = args.car();
        if (!(countObj instanceof LispNumber)) {
            throw new IllegalArgumentException('iota: COUNT must be a number');
        }
        Integer count = ((LispNumber)countObj).unwrap().intValue();
        if (count < 0) throw new IllegalArgumentException('iota: COUNT cannot be negative');

        LispObject startObj = args.cdr().isNil() ? new LispNumber(0) : args.cdar();
        if (!(startObj instanceof LispNumber)) {
            throw new IllegalArgumentException('iota: START must be a number');
        }
        Decimal start = ((LispNumber)startObj).unwrap();

        LispObject stepObj = args.cddr().isNil() ? new LispNumber(1) : args.cddar();
        if (!(stepObj instanceof LispNumber)) {
            throw new IllegalArgumentException('iota: STEP must be a number');
        }
        Decimal step = ((LispNumber)stepObj).unwrap();

        LispObject result = LispNil.INSTANCE;

        for (Integer i = count - 1; i >= 0; i--) {
            result = new LispCons(new LispNumber(start + (step * i)), result);
        }

        return result;
    }
}
