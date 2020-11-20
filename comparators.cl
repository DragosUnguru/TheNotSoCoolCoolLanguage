-- Interface
class Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {{ abort(); true; }};
};

class PriceComparator inherits Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj1 of
                dummy1 : Product =>
                    case obj2 of
                        dummy2 : Product => if dummy1.getprice() < dummy2.getprice() then result <- true else result <- false fi;
                        any_other2 : MySuperClass => abort();
                    esac;
                any_other1 : MySuperClass => abort();
            esac;

            result;
        }
    };
};

class RankComparator inherits Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj1 of
                dummy1 : Rank =>
                    case obj2 of
                        dummy2 : Rank => if dummy1.getRankHierarchy() < dummy2.getRankHierarchy() then result <- false else result <- true fi;
                        any_other2 : MySuperClass => abort();
                    esac;
                any_other1 : MySuperClass => abort();
            esac;

            result;
        }
    };
};

class AlphabeticComparator inherits Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj1 of
                dummy1 : StringWrapper =>
                    case obj2 of
                        dummy2 : StringWrapper => if dummy1.getString() < dummy2.getString() then result <- true else result <- false fi;
                        any_other2 : MySuperClass => abort();
                    esac;
                any_other1 : MySuperClass => abort();
            esac;

            result;
        }
    };
};
