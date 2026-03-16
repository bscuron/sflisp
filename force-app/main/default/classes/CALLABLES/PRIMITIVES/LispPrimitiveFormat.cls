public class LispPrimitiveFormat extends LispPrimitive {

    public LispPrimitiveFormat() {
        super('(format STRING &rest OBJECTS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        String formatString = ((LispString)(args.car())).toString();

        List<Object> formatObjects = new List<Object>();
        LispObject iter = args.cdr();
        while (!iter.isNil()) {
            formatObjects.add(((LispCons)iter).car());
            iter = ((LispCons)iter).cdr();
        }

        return new LispString(String.format(formatString, formatObjects));
    }
}
