-- Interface
class Filter {
    apply(obj : MySuperClass) : Bool {{ abort(); true; }};
};

class ProductFilter inherits Filter {
    apply(obj : MySuperClass) : Bool {
        {
            case obj of 
                product : Product => true;
                --No need to check for every other type individually.
                any_other : MySuperClass => false;
            esac;
        }
    };
};

class RankFilter inherits Filter {
    apply(obj : MySuperClass) : Bool {
        {
            case obj of
                rank : Rank => true;
                --No need to check for every other type individually.
                any_other : MySuperClass => false;
            esac;
        }
    };
};

class SamePriceFilter inherits Filter {
    apply(obj : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj of 
                product : Product => result <- product.getprice() = new Product.init("", "", product.price()).getprice();
                any_other : MySuperClass => false;
            esac;

            result;
        }
    };
};