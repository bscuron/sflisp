public class LispSignature {
    public String name;
    public List<LispSymbol> requiredParameters;
    public List<LispSymbol> optionalParameters;
    public LispSymbol restParameter;

    public LispSignature(String signature) {
        this(parse(signature));
    }

    public LispSignature(LispObject obj) {
        requiredParameters = new List<LispSymbol>();
        optionalParameters = new List<LispSymbol>();
        restParameter = null;

        System.assert(obj instanceof LispCons || obj.isNil(), 'Invalid signature: ' + obj);

        Boolean parsingOptional = false;
        LispObject iter = (LispCons)obj;
        LispObject nameSym = iter.car();
        if (!(nameSym instanceof LispSymbol)) {
            System.assert(false, 'Signature name parameter must be a symbol: ' + nameSym);
        }
        name = nameSym.toString();
        iter = iter.cdr();

        while (!iter.isNil()) {
            LispObject param = iter.car();
            if (!(param instanceof LispSymbol)) {
                System.assert(false, 'Signature parameters must be symbols: ' + param);
            }

            LispSymbol sym = (LispSymbol)param;
            if (sym == LispSymbol.intern('&optional')) {
                parsingOptional = true;
            } else if (sym == LispSymbol.intern('&rest')) {
                iter = iter.cdr();
                System.assert(!iter.isNil(), 'Expected symbol after &rest');
                restParameter = (LispSymbol)iter.car();
                break;
            } else {
                if (parsingOptional) {
                    optionalParameters.add(sym);
                } else {
                    requiredParameters.add(sym);
                }
            }

            iter = iter.cdr();
        }
    }

    private static LispObject parse(String signature) {
        List<LispLexer.Token> tokens = LispLexer.tokenize(signature);
        List<LispObject> objs = LispParser.parse(tokens);
        System.assert(objs.size() == 1, 'Invalid signature: ' + signature);
        return objs[0];
    }

    public override String toString() {
        String s = '(' + name;
        if (!requiredParameters.isEmpty()) {
            for (LispObject sym: requiredParameters) {
                s += ' ' + sym.toString();
            }
        }
        if (!optionalParameters.isEmpty()) {
            s += ' &optional';
            for (LispObject sym: optionalParameters) {
                s += ' ' + sym.toString();
            }
        }
        if (restParameter != null) {
            s += ' &rest ' + restParameter;
        }
        s += ')';
        return s;
    }
}
