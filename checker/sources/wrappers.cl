class StringWrapper inherits MySuperClass {
    string : String;

    init(str : String) : SELF_TYPE {
        {
            string <- str;
            self;
        }
    };

    toString() : String {
        "String".concat("(").concat(string).concat(")")
    };

    getString() : String {
        string
    };

    concat(str : String) : SELF_TYPE {
        {
            string.concat(str);
            self;
        }
    };
};

class IntWrapper inherits MySuperClass {
    number : Int;

    init(integer : Int) : SELF_TYPE {
        {
            number <- integer;
            self;
        }
    };

    toString() : String {
        "Int".concat("(").concat(new A2I.i2a(number)).concat(")")
    };
};

class IOWrapper inherits MySuperClass {
    
    init() : SELF_TYPE { self };

    toString() : String {
        "IO()"
    };
};

class BooleanWrapper inherits MySuperClass {
    instance : Bool;

    init(boolean : String) : SELF_TYPE {
        {
            if boolean = "true" then instance <- true else instance <- false fi;
            self;
        }
    };

    toString() : String {
        if instance = true then "Bool(true)" else "Bool(false)" fi
    };
};
