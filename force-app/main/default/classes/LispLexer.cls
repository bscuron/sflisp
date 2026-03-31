public class LispLexer {
    private String source;
    private Integer offset;
    private Integer line;
    private Integer lineOffset;
    private Integer column {
        private get {
            return offset - lineOffset;
        }
        private set {
        }
    }
    private Integer column() {
        return offset - lineOffset;
    }

    public enum TokenType {
        TLPAREN,
        TRPAREN,
        TQUOTE,
        TDOT,
        TQUASIQUOTE,
        TUNQUOTE,
        TUNQUOTESPLICING,
        TCOMMENT,
        TNUMBER,
        TSTRING,
        TSYMBOL,
        TEOF,
        TUNKNOWN
    }

    public class Token {
        public TokenType type;
        private LispLexer lexer;
        private Integer line;
        private Integer column;
        private Integer start;
        private Integer stop;

        public Token(LispLexer lexer, TokenType type, Integer start, Integer stop, Integer line, Integer column) {
            this.lexer = lexer;
            this.type = type;
            this.start = start;
            this.stop = stop;
            this.line = line;
            this.column = column;
        }

        public String value() {
            return this.lexer.source.substring(this.start, this.stop);
        }

        public override String toString() {
            return 'Token(' + type + ',' + value() + ') @ ' + line + 'L' + column + 'C';
        }
    }

    private LispLexer(String source) {
        this.source = source;
        this.offset = 0;
        this.line = 0;
        this.lineOffset = 0;
    }

    public static List<Token> tokenize(string input) {
        LispLexer lexer = new LispLexer(input);
        List<Token> tokens = new List<Token>();

        Token token;
        while (!lexer.empty()) {
            lexer.skipWhite();
            if (lexer.empty()) {
                token = lexer.chopn(TokenType.TEOF, 0);
            } else {
                Integer c = lexer.peek(0);
                Integer cc = lexer.peekSafe(1);
                if (c == 40) { // (
                    token = lexer.chopn(TokenType.TLPAREN, 1);
                } else if (c == 41) { // )
                    token = lexer.chopn(TokenType.TRPAREN, 1);
                } else if (c == 46) { // .
                    token = lexer.chopn(TokenType.TDOT, 1);
                } else if (c == 44 && cc == 64) { // ,@
                    token = lexer.chopn(TokenType.TUNQUOTESPLICING, 2);
                } else if (c == 44) { // ,
                    token = lexer.chopn(TokenType.TUNQUOTE, 1);
                } else if (c == 39) { // '
                    token = lexer.chopn(TokenType.TQUOTE, 1);
                } else if (c == 96) { // `
                    token = lexer.chopn(TokenType.TQUASIQUOTE, 1);
                } else if (c == 45 && isDigit(cc)) { // -[0-9]
                    token = lexer.chopNumber();
                } else if (isDigit(c)) { // [0-9]
                    token = lexer.chopNumber();
                } else if (c == 34) { // "
                    token = lexer.chopString();
                } else if (c == 59) { // ;
                    token = lexer.chopComment();
                } else {
                    token = lexer.chopSymbol();
                }
            }
            tokens.add(token);
        }
        token = lexer.chopn(TokenType.TEOF, 0);
        tokens.add(token);

        return tokens;
    }

    private Token chopSymbol() {
        Integer start = offset;
        Integer column = column;
        offset++;

        while (!empty()) {
            Integer c = peek(0);
            if (c == 32 || c == 10 || c == 9 || c == 13 // whitespace
                || c == 40 || c == 41 // ( )
                || c == 34 // "
                || c == 59 // ;
                || c == 39 // '
                || c == 96  // `
            ) {
                break;
            } else {
                offset++;
            }
        }

        return new Token(this, TokenType.TSYMBOL, start, offset, line, column);
    }

    private Token chopString() {
        Integer start = offset;
        Integer column = column;
        offset++;

        while (!empty()) {
            Integer c = peek(0);
            offset++;
            if (c == 10) { // \n
                line++;
                lineOffset = offset;
            } else if (c == 34) { // "
                return new Token(this, TokenType.TSTRING, start + 1, offset - 1, line, column);
            }
        }

        return new Token(this, TokenType.TUNKNOWN, start, offset, line, column);
    }

    private Token chopComment() {
        Integer start = offset;
        Integer column = column;
        offset++;
        while (!empty()) {
            if (peek(0) == 10) { // \n
                offset++;
                line++;
                lineOffset = offset;
                break;
            }
            offset++;
        }
        return new Token(this, TokenType.TCOMMENT, start, offset, line, column);
    }

    private Token chopNumber() {
        Integer start = offset;
        Integer column = column;
        offset++;

        Boolean isFloat = false;
        while (!empty()) {
            if (isDigit(peek(0))) {
                offset++;
            } else {
                break;
            }
        }
        if (peek(0) == 46 && isDigit(peekSafe(1))) {
            offset += 2;
            while (!empty()) {
                if (isDigit(peek(0))) {
                    offset++;
                } else {
                    break;
                }
            }
        }

        return new Token(this, TokenType.TNUMBER, start, offset, line, column);
    }

    private Token chopn(TokenType type, Integer n) {
        Token token;
        Integer start = offset;
        Integer stop = offset + n;
        token = new Token(this, type, start, stop, line, column);
        offset += n;
        return token;
    }

    private Integer peek(Integer n) {
        return source.charAt(offset + n);
    }

    private Integer peekSafe(Integer n) {
        Integer i = offset + n;
        return i >= 0 && i < source.length() ? source.charAt(i) : -1;
    }

    private static Boolean isDigit(Integer i) {
        return i >= 48 && i <= 57;
    }

    private void skipWhite() {
        while (!empty()) {
            Integer c = peek(0);
            if (c == 10) { // \n
                offset++;
                line++;
                lineOffset = offset;
            } else if (c == 32 || (c >= 9 && c <= 13)) { // ascii whitespace
                offset++;
            } else {
                break;
            }
        }
    }

    private Boolean empty() {
        return offset >= source.length();
    }
}
