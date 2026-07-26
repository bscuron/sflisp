// TODO:
// - tests
// - mismatched parens/brackets
// - bounds checking
public class LispReader {
    public LispHeap heap;

    private final String src;
    private final List<Integer> chars;
    private final Integer length;
    private Integer line;
    private Integer offset;

    public LispReader(String src) {
        this.src = src;
        this.chars = src.getChars();
        this.length = this.chars.size();
        this.offset = 0;
        this.line = 1;
        this.heap = new LispHeap();
    }

    public List<Long> readAll() {
        List<Long> values = new List<Long>();

        while (offset < length) {
            skipWhitespaceAndComments();

            if (offset >= length) {
                break;
            }

            values.add(readExpr());
        }

        return values;
    }

    private Long readExpr() {
        skipWhitespaceAndComments();

        Integer c = chars[offset];

        if (c == ASCII_LEFT_PARENTHESIS) {
            return readList(ASCII_RIGHT_PARENTHESIS);
        }

        if (c == ASCII_LEFT_BRACKET) {
            return readList(ASCII_RIGHT_BRACKET);
        }

        if (c == ASCII_SINGLE_QUOTE) {
            return readQuote();
        }

        return readFixnumFlonumSymbol();
    }

    private Long readFixnumFlonumSymbol() {
        Integer start = offset;

        Boolean negative = false;
        Integer c = chars[offset];

        if (c == ASCII_PLUS || c == ASCII_MINUS) {
            negative = c == ASCII_MINUS;
            ++offset;
        }

        if (offset < length
            && chars[offset] == ASCII_PERIOD
            && offset + 1 < length
            && isDigit(chars[offset + 1])) {

            return readFlonum(start, 0L, negative);
        }

        Long fixnumPart = 0L;
        Boolean hasDigits = false;

        while (offset < length) {
            c = chars[offset];

            if (isDigit(c)) {
                fixnumPart = fixnumPart * 10 + (c - ASCII_DIGIT_0);
                hasDigits = true;
                ++offset;
            } else {
                break;
            }
        }

        if (!hasDigits) {
            offset = start;
            return readSymbol();
        }

        if (offset >= length || isDelimiter(chars[offset])) {
            return LispValue.makeFixnum(negative ? -fixnumPart : fixnumPart);
        }

        if (chars[offset] == ASCII_PERIOD
            || chars[offset] == ASCII_UPPER_E
            || chars[offset] == ASCII_LOWER_E) {

            return readFlonum(start, fixnumPart, negative);
        }

        offset = start;
        return readSymbol();
    }

    private Long readFlonum(Integer start, Long integerPart, Boolean negative) {
        Double value = integerPart;

        if (offset < length && chars[offset] == ASCII_PERIOD) {
            ++offset;

            Double fraction = 0;
            Integer digits = 0;

            while (offset < length) {
                Integer c = chars[offset];

                if (isDigit(c)) {
                    fraction = fraction * 10 + (c - ASCII_DIGIT_0);
                    ++digits;
                    ++offset;
                } else {
                    break;
                }
            }

            if (digits > 0) {
                Double divisor = 1;
                for (Integer i = 0; i < digits; i++) {
                    divisor *= 10;
                }

                value += fraction / divisor;
            }
        }

        if (offset < length &&
            (chars[offset] == ASCII_UPPER_E || chars[offset] == ASCII_LOWER_E)) {

            ++offset;

            Boolean exponentNegative = false;

            if (offset < length &&
                (chars[offset] == ASCII_PLUS || chars[offset] == ASCII_MINUS)) {

                exponentNegative = chars[offset] == ASCII_MINUS;
                ++offset;
            }

            Integer exponent = 0;
            Boolean hasExponentDigits = false;

            while (offset < length) {
                Integer c = chars[offset];

                if (isDigit(c)) {
                    exponent = exponent * 10 + (c - ASCII_DIGIT_0);
                    hasExponentDigits = true;
                    ++offset;
                } else {
                    break;
                }
            }

            if (!hasExponentDigits) {
                offset = start;
                return readSymbol();
            }

            Double multiplier = 1;

            if (exponentNegative) {
                while (exponent-- > 0) {
                    multiplier /= 10;
                }
            } else {
                while (exponent-- > 0) {
                    multiplier *= 10;
                }
            }

            value *= multiplier;
        }

        if (offset < length && !isDelimiter(chars[offset])) {
            offset = start;
            return readSymbol();
        }

        if (negative) {
            value = -value;
        }

        return heap.allocFlonum(value);
    }

    private Long readList(Integer match) {
        ++offset;

        skipWhitespaceAndComments();

        if (chars[offset] == match) {
            ++offset;
            return LispValue.EMPTY_LIST;
        }

        Long first = readExpr();
        Long head = heap.allocPair(first, LispValue.EMPTY_LIST);
        Long tail = head;

        while (true) {
            skipWhitespaceAndComments();

            if (chars[offset] == match) {
                ++offset;
                break;
            }

            Long value = readExpr();
            Long next = heap.allocPair(value, LispValue.EMPTY_LIST);
            heap.setCdr(tail, next);
            tail = next;
        }

        return head;
    }

    private Long readQuote() {
        ++offset;

        Long symbolQuote = heap.allocSymbol('quote');
        Long expr = readExpr();

        return heap.allocPair(symbolQuote, heap.allocPair(expr, LispValue.EMPTY_LIST));
    }

    private Long readSymbol() {
        Integer start = offset;

        while (offset < length && !isDelimiter(chars[offset])) {
            ++offset;
        }

        return heap.allocSymbol(src.substring(start, offset));
    }

    private void skipWhitespaceAndComments() {
        Integer c;
        while (offset < length) {
            c = chars[offset];

            if (c == ASCII_NEWLINE) {
                ++offset;
                ++line;
            } else if (c == ASCII_SPACE
                       || (c >= ASCII_HORIZONTAL_TAB && c <= ASCII_CARRIAGE_RETURN)) {
                ++offset;
            } else if (c == ASCII_SEMICOLON) {
                while (offset < length && chars[offset] != ASCII_NEWLINE) {
                    ++offset;
                }
            } else if (c == ASCII_POUND && offset + 1 < length && chars[offset + 1] == ASCII_SEMICOLON) {
                offset += 2;
                skipWhitespaceAndComments();
                readExpr();
            } else {
                break;
            }
        }
    }

    private Boolean isDigit(Integer c) {
        return c >= ASCII_DIGIT_0 && c <= ASCII_DIGIT_9;
    }

    private Boolean isDelimiter(Integer c) {
        return c == ASCII_SPACE
            || (c >= ASCII_HORIZONTAL_TAB && c <= ASCII_CARRIAGE_RETURN)
            || c == ASCII_LEFT_PARENTHESIS
            || c == ASCII_RIGHT_PARENTHESIS
            || c == ASCII_LEFT_BRACKET
            || c == ASCII_RIGHT_BRACKET
            || c == ASCII_SINGLE_QUOTE
            || c == ASCII_DOUBLE_QUOTE;
    }

    private static final Integer ASCII_SPACE = 32;
    private static final Integer ASCII_HORIZONTAL_TAB = 9;
    private static final Integer ASCII_NEWLINE = 10;
    private static final Integer ASCII_CARRIAGE_RETURN = 13;
    private static final Integer ASCII_SINGLE_QUOTE = 39;
    private static final Integer ASCII_DOUBLE_QUOTE = 34;
    private static final Integer ASCII_LEFT_PARENTHESIS = 40;
    private static final Integer ASCII_RIGHT_PARENTHESIS = 41;
    private static final Integer ASCII_LEFT_BRACKET = 91;
    private static final Integer ASCII_RIGHT_BRACKET = 93;
    private static final Integer ASCII_DIGIT_0 = 48;
    private static final Integer ASCII_DIGIT_9 = 57;
    private static final Integer ASCII_SEMICOLON = 59;
    private static final Integer ASCII_POUND = 35;
    private static final Integer ASCII_UPPER_E = 69;
    private static final Integer ASCII_MINUS  = 45;
    private static final Integer ASCII_PERIOD = 46;
    private static final Integer ASCII_PLUS = 43;
    private static final Integer ASCII_LOWER_E = 101;
    private static final Integer ASCII_BACKSLASH = 92;
}
