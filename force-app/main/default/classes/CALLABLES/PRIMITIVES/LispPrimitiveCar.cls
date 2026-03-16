public class LispPrimitiveCar extends LispPrimitive {

    public LispPrimitiveCar() {
        super('(car LIST)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject cons = args.car().eval(env);

        if (!(cons instanceof LispCons)) {
            throw new IllegalArgumentException('car expects a cons cell');
        }

        return ((LispCons)cons).car();
    }
}
