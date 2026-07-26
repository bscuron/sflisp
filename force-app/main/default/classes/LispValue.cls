public class LispValue {
    // [PAYLOAD 61 BITS][TAG 3 BITS]
    private static final Long TAG_MASK      = 7L; // 0b111
    private static final Long TAG_FIXNUM    = 0L; // 0b000
    private static final Long TAG_PAIR      = 1L; // 0b001
    private static final Long TAG_FLONUM    = 2L; // 0b010
    private static final Long TAG_SYMBOL    = 3L; // 0b011
    private static final Long TAG_STRING    = 4L; // 0b100
    private static final Long TAG_VECTOR    = 5L; // 0b101
    private static final Long TAG_CLOSURE   = 6L; // 0b110
    private static final Long TAG_IMMEDIATE = 7L; // 0b111

    public static final Long EMPTY_LIST  = makeImmediate(0L);
    public static final Long TRUE_VALUE  = makeImmediate(1L);
    public static final Long FALSE_VALUE = makeImmediate(2L);

    public static Long make(Long value, Long tag) {
        return (value << 3) | tag;
    }

    public static Long makeFixnum(Long value) {
        return make(value, TAG_FIXNUM);
    }

    public static Long makePair(Long index) {
        return make(index, TAG_PAIR);
    }

    public static Long makeFlonum(Long index) {
        return make(index, TAG_FLONUM);
    }

    public static Long makeSymbol(Long index) {
        return make(index, TAG_SYMBOL);
    }

    public static Long makeString(Long index) {
        return make(index, TAG_STRING);
    }

    public static Long makeVector(Long index) {
        return make(index, TAG_VECTOR);
    }

    public static Long makeClosure(Long index) {
        return make(index, TAG_CLOSURE);
    }

    public static Long makeImmediate(Long value) {
        return make(value, TAG_IMMEDIATE);
    }

    // XXX: for debug use only
    public static String tagName(Long value) {
        Long t = tag(value);
        if (t == TAG_FIXNUM)            return 'TAG_FIXNUM';
        else if (t == TAG_PAIR)         return 'TAG_PAIR';
        else if (t == TAG_FLONUM)       return 'TAG_FLONUM';
        else if (t == TAG_SYMBOL)       return 'TAG_SYMBOL';
        else if (t == TAG_STRING)       return 'TAG_STRING';
        else if (t == TAG_VECTOR)       return 'TAG_VECTOR';
        else if (t == TAG_CLOSURE)      return 'TAG_CLOSURE';
        else if (t == TAG_IMMEDIATE)    return 'TAG_IMMEDIATE';
        else                            return 'UNKNOWN';
    }

    public static Long tag(Long value) {
        return value & TAG_MASK;
    }

    public static Integer index(Long value) {
        return (Integer)(value >> 3);
    }

    public static Long payload(Long value) {
        return value >> 3;
    }

    public static Long fixnum(Long value) {
        return value >> 3;
    }

    public static Boolean isSymbol(Long value) {
        return tag(value) == TAG_SYMBOL;
    }

    public static Boolean isFixnum(Long value) {
        return tag(value) == TAG_FIXNUM;
    }

    public static Boolean isPair(Long value) {
        return tag(value) == TAG_PAIR;
    }

    public static Boolean isFlonum(Long value) {
        return tag(value) == TAG_FLONUM;
    }

    public static Boolean isString(Long value) {
        return tag(value) == TAG_STRING;
    }

    public static Boolean isVector(Long value) {
        return tag(value) == TAG_VECTOR;
    }

    public static Boolean isClosure(Long value) {
        return tag(value) == TAG_CLOSURE;
    }

    public static Boolean isImmediate(Long value) {
        return tag(value) == TAG_IMMEDIATE;
    }

    public static Boolean isEmptyList(Long value) {
        return value == EMPTY_LIST;
    }

    public static Boolean isTruthy(Long value) {
        return value != FALSE_VALUE;
    }

    public static Boolean isFalsey(Long value) {
        return value == FALSE_VALUE;
    }

    public static Boolean isHeapObject(Long value) {
        Long t = tag(value);
        return t == TAG_PAIR
            || t == TAG_SYMBOL
            || t == TAG_FLONUM
            || t == TAG_STRING
            || t == TAG_VECTOR
            || t == TAG_CLOSURE;
    }
}
