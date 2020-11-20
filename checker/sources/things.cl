(*******************************
 *** Classes Product-related ***
 *******************************)

class MySuperClass inherits IO {
    toString() : String {
        {
            abort(); "";
        }
    };

    getString() : String { { abort(); new String; } };
};

class Product inherits MySuperClass {
    name : String;
    model : String;
    price : Int;

    init(n : String, m: String, p : Int) : SELF_TYPE {{
        name <- n;
        model <- m;
        price <- p;
        self;
    }};

    price() : Int { price };

    getprice() : Int{ price * 119 / 100 };

    toString() : String {
        type_name().concat("(").concat(name).concat(";").concat(model).concat(")")
    };
};

class Edible inherits Product {
    -- VAT tax is lower for foods
    getprice():Int { price * 109 / 100 };
};

class Soda inherits Edible {
    -- sugar tax is 20 bani
    getprice():Int {price * 109 / 100 + 20};
};

class Coffee inherits Edible {
    -- this is technically poison for ants
    getprice():Int {price * 119 / 100};
};

class Laptop inherits Product {
    -- operating system cost included
    getprice():Int {price * 119 / 100 + 499};
};

class Router inherits Product {};

(****************************
 *** Classes Rank-related ***
 ****************************)
class Rank inherits MySuperClass {
    name : String;

    init(n : String) : SELF_TYPE {{
        name <- n;
        self;
    }};

    toString() : String {
        type_name().concat("(").concat(name).concat(")")
    };

    getRankHierarchy() : Int {{ abort(); 0; }};
};

class Private inherits Rank {
    getRankHierarchy() : Int {
        4
    };
};

class Corporal inherits Private {
    getRankHierarchy() : Int {
        3
    };
};

class Sergent inherits Corporal {
    getRankHierarchy() : Int {
        2
    };
};

class Officer inherits Sergent {
    getRankHierarchy() : Int {
        1
    };
};

