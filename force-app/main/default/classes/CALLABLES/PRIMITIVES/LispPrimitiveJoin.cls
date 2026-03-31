public class LispPrimitiveJoin extends LispPrimitive {

    public LispPrimitiveJoin() {
        super('(join SEQUENCE &optional DELIMITER)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject sequenceObj = args.car().eval(env);

        String delimiter = ' ';
        if (!args.cdr().isNil()) {
            LispObject delimObj = args.cdar().eval(env);
            if (!(delimObj instanceof LispString)) {
                throw new IllegalArgumentException('join: DELIMITER must be a string');
            }
            delimiter = ((LispString)delimObj).toString();
        }

        List<String> elements = new List<String>();
        LispObject iter = sequenceObj;
        while (!iter.isNil()) {
            LispObject item = iter.car();
            elements.add(item.toString());
            iter = iter.cdr();
        }

        return new LispString(String.join(elements, delimiter));
    }
}
