public class LispHeap {
    private List<Long> cars = new List<Long>();
    private List<Long> cdrs = new List<Long>();
    private List<String> symbols = new List<String>();
    private Map<String, Long> symbolTable = new Map<String, Long>();
    private List<String> strings = new List<String>();
    private List<Double> flonums = new List<Double>();

    public Long allocPair(Long car, Long cdr) {
        Integer index = cars.size();

        cars.add(car);
        cdrs.add(cdr);

        return LispValue.makePair(index);
    }

    public Long allocSymbol(String name) {
        Long existing = symbolTable.get(name);

        if (existing != null) {
            return existing;
        }

        Integer index = symbols.size();
        Long value = LispValue.makeSymbol(index);

        symbols.add(name);
        symbolTable.put(name, value);

        return value;
    }

    public Long allocString(String value) {
        Integer index = strings.size();

        strings.add(value);

        return LispValue.makeString(index);
    }

    public Long allocFlonum(Double value) {
        Integer index = flonums.size();

        flonums.add(value);

        return LispValue.makeFlonum(index);
    }

    public void setCar(Long pair, Long value) {
        cars[LispValue.index(pair)] = value;
    }

    public void setCdr(Long pair, Long value) {
        cdrs[LispValue.index(pair)] = value;
    }

    public Long car(Long pair) {
        return cars[LispValue.index(pair)];
    }

    public Long cdr(Long pair) {
        return cdrs[LispValue.index(pair)];
    }

    public String getSymbol(Long symbol) {
        return symbols[LispValue.index(symbol)];
    }

    public String getString(Long str) {
        return strings[LispValue.index(str)];
    }

    public Double getFlonum(Long flonum) {
        return flonums[LispValue.index(flonum)];
    }
}
