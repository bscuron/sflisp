public class LispPrimitiveReverse extends LispPrimitive {

    public LispPrimitiveReverse() {
        super('(reverse SEQ)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject seq = args.car();

        if (seq instanceof LispString) {
            return new LispString(seq.toString().reverse());
        } 
        else if (seq instanceof LispCons) {
            LispObject result = LispNil.INSTANCE;
            LispObject current = seq;

            while (current instanceof LispCons) {
                LispCons cons = (LispCons) current;
                result = new LispCons(cons.car(), result);
                current = cons.cdr();
            }

            return result;
        } 
        else if (seq instanceof LispNil) {
            return LispNil.INSTANCE;
        }

        throw new IllegalArgumentException('reverse: unsupported type ' + seq);
    }
}
