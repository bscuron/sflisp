public class LispParser {
    private Integer offset;
    private List<LispLexer.Token> tokens;

    public static List<LispObject> parse(List<LispLexer.Token> tokens) {
        LispParser parser = new LispParser(tokens);
        List<LispObject> objs = new List<LispObject>();
        while (!parser.empty()) {
            LispObject obj = parser.parseValue();
            if (obj != null) objs.add(obj);
        }
        return objs;
    }

    private LispParser(List<LispLexer.Token> tokens) {
        this.tokens = tokens;
        this.offset = 0;
    }

    private Boolean empty() {
        return offset >= tokens.size();
    }

    private void skipComments() {
        while (!empty() && tokens[offset].type == LispLexer.TokenType.TCOMMENT) {
            offset++;
        }
    }

    public LispObject parseValue() {
        skipComments();
        if (empty()) return null;

        LispLexer.Token token = tokens[offset];
        offset++;

        switch on token.type {
                when TSYMBOL {
                    return LispSymbol.intern(token.value());
                }
                when TSTRING {
                    return new LispString(token.value());
                }
                when TNUMBER {
                    return new LispNumber(Decimal.valueOf(token.value()));
                }
                when TLPAREN {
                    return parseList();
                }
                when TQUOTE {
                    return new LispCons(
                        LispSymbol.intern('quote'),
                        new LispCons(parseValue(), LispNil.INSTANCE)
                    );
                }
                when TQUASIQUOTE {
                    return new LispCons(
                        LispSymbol.intern('quasiquote'),
                        new LispCons(parseValue(), LispNil.INSTANCE)
                    );
                }
                when TUNQUOTE {
                    return new LispCons(
                        LispSymbol.intern('unquote'),
                        new LispCons(parseValue(), LispNil.INSTANCE)
                    );
                }
                when TUNQUOTESPLICING {
                    return new LispCons(
                        LispSymbol.intern('unquote-splicing'),
                        new LispCons(parseValue(), LispNil.INSTANCE)
                    );
                }
                when TEOF {
                    return null;
                }
                when else {
                    System.assert(false, 'ERROR: Unknown token: ' + token);
                    return null;
                }
            }
    }

    private LispObject parseList() {
        if (empty()) {
            System.assert(false, 'ERROR: Unexpected end of input while parsing list');
        }

        skipComments();

        if (empty() || tokens[offset].type == LispLexer.TokenType.TRPAREN) {
            if (!empty()) offset++;
            return LispNil.INSTANCE;
        }

        LispObject car = parseValue();

        skipComments();

        if (!empty() && tokens[offset].type == LispLexer.TokenType.TDOT) {
            offset++;
            LispObject cdr = parseValue();
            if (empty() || tokens[offset].type != LispLexer.TokenType.TRPAREN) {
                System.assert(false, 'ERROR: Expected ) after dotted pair');
            }
            offset++;
            return new LispCons(car, cdr);
        }

        LispObject cdr = parseList();
        return new LispCons(car, cdr);
    }
}
