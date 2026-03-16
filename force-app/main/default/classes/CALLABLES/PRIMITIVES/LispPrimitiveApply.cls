public class LispPrimitiveApply extends LispPrimitive {

    public LispPrimitiveApply() {
        super('(apply FUNCTION &rest ARGUMENTS)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject fnObj = args.car().eval(env);
        if (!(fnObj instanceof LispCallable)) {
            throw new IllegalArgumentException('apply: first argument must be callable');
        }
        LispCallable fn = (LispCallable)fnObj;
        LispObject flattenedArgs = flattenArgs(args.cdr(), env);
        fn.validateArguments(flattenedArgs);
        return fn.apply(flattenedArgs, env);
    }

    private LispObject flattenArgs(LispObject argList, LispEnvironment env) {
        return flattenArgsRecursive(argList, env, LispNil.INSTANCE);
    }

    private LispObject flattenArgsRecursive(LispObject remaining, LispEnvironment env, LispObject acc) {
        if (remaining.isNil()) {
            return acc;
        }
        if (remaining.cdr().isNil()) {
            LispObject lastArg = remaining.car().eval(env);
            return appendFlattened(acc, lastArg);
        } else {
            LispObject evaluated = remaining.car().eval(env);
            acc = append(acc, evaluated);
            return flattenArgsRecursive(remaining.cdr(), env, acc);
        }
    }

    private LispObject append(LispObject chain, LispObject element) {
        if (chain.isNil()) return new LispCons(element, LispNil.INSTANCE);
        LispCons head = (LispCons) chain;
        return new LispCons(head.car(), append(head.cdr(), element));
    }

    private LispObject appendFlattened(LispObject chain, LispObject lastArg) {
        if (lastArg.isNil()) return chain;
        if (lastArg instanceof LispCons) {
            LispObject iter = lastArg;
            while (iter instanceof LispCons) {
                chain = append(chain, iter.car());
                iter = iter.cdr();
            }
            if (!iter.isNil()) {
                chain = append(chain, iter);
            }
        } else {
            chain = append(chain, lastArg);
        }
        return chain;
    }
}
