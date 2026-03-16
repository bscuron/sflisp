public abstract class LispObject {

    protected LispObject() {}

    public virtual LispObject eval(LispEnvironment env) {
        return this;
    }

    public virtual LispObject car() { return LispNil.INSTANCE; }
    public virtual LispObject cdr() { return LispNil.INSTANCE; }
    public virtual LispObject caar()  { return car().car(); }
    public virtual LispObject cadr()  { return car().cdr(); }
    public virtual LispObject cdar()  { return cdr().car(); }
    public virtual LispObject cddr()  { return cdr().cdr(); }
    public virtual LispObject caaar()  { return car().car().car(); }
    public virtual LispObject caadr()  { return car().car().cdr(); }
    public virtual LispObject cadar()  { return car().cdr().car(); }
    public virtual LispObject caddr()  { return car().cdr().cdr(); }
    public virtual LispObject cdaar()  { return cdr().car().car(); }
    public virtual LispObject cdadr()  { return cdr().car().cdr(); }
    public virtual LispObject cddar()  { return cdr().cdr().car(); }
    public virtual LispObject cdddr()  { return cdr().cdr().cdr(); }
    public virtual LispObject caaaar()  { return car().car().car().car(); }
    public virtual LispObject caaadr()  { return car().car().car().cdr(); }
    public virtual LispObject caadar()  { return car().car().cdr().car(); }
    public virtual LispObject caaddr()  { return car().car().cdr().cdr(); }
    public virtual LispObject cadaar()  { return car().cdr().car().car(); }
    public virtual LispObject cadadr()  { return car().cdr().car().cdr(); }
    public virtual LispObject caddar()  { return car().cdr().cdr().car(); }
    public virtual LispObject cadddr()  { return car().cdr().cdr().cdr(); }
    public virtual LispObject cdaaar()  { return cdr().car().car().car(); }
    public virtual LispObject cdaadr()  { return cdr().car().car().cdr(); }
    public virtual LispObject cdadar()  { return cdr().car().cdr().car(); }
    public virtual LispObject cdaddr()  { return cdr().car().cdr().cdr(); }
    public virtual LispObject cddaar()  { return cdr().cdr().car().car(); }
    public virtual LispObject cddadr()  { return cdr().cdr().car().cdr(); }
    public virtual LispObject cdddar()  { return cdr().cdr().cdr().car(); }
    public virtual LispObject cddddr()  { return cdr().cdr().cdr().cdr(); }

    public virtual Boolean isNil() {
        return false;
    }

    public virtual Boolean isT() {
        return true;
    }

}
