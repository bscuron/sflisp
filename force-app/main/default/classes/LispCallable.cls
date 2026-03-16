public abstract class LispCallable extends LispObject {
    public LispSignature signature;

    public LispCallable(String signature) {
        this.signature = new LispSignature(signature);
    }

    public LispCallable(LispSignature signature) {
        this.signature = signature;
    }

    public abstract LispObject apply(LispObject args, LispEnvironment env);

    public void validateArguments(LispObject args) {
        Integer count = 0;
        LispObject iter = args;
        while (!iter.isNil()) {
            count++;
            iter = iter.cdr();
        }

        if (count < signature.requiredParameters.size()) {
            System.assert(false, this + ': too few arguments');
        }

        if (signature.restParameter == null && count > signature.requiredParameters.size() + signature.optionalParameters.size()) {
            System.assert(false, this + ': too many arguments');
        }
    }

    public override String toString() {
        return signature.toString();
    }
}
