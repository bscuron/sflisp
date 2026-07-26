public class LispWriter {

    private LispHeap heap;

    public LispWriter(LispHeap heap) {
        this.heap = heap;
    }

    public String write(Long value) {
        if (LispValue.isEmptyList(value)) {
            return '()';
        }

        if (LispValue.isFixnum(value)) {
            return LispValue.fixnum(value).toString();
        }

        if (LispValue.isFlonum(value)) {
            return heap.getFlonum(value).toString();
        }

        if (LispValue.isSymbol(value)) {
            return heap.getSymbol(value);
        }

        if (LispValue.isString(value)) {
            return '"' + heap.getString(value) + '"';
        }

        if (LispValue.isPair(value)) {
            return writeList(value);
        }

        return '#<unknown>';
    }

    private String writeList(Long pair) {
        String result = '(';

        while (LispValue.isPair(pair)) {
            result += write(heap.car(pair));

            Long next = heap.cdr(pair);

            if (!LispValue.isEmptyList(next)) {
                result += ' ';
            }

            pair = next;
        }

        result += ')';

        return result;
    }
}
