class Tokenizer {
    line : String;
    delimiter : String <- " ";
    tokens : List;

    -- Initialize Tokenizer
    init(ln : String) : Tokenizer {
        let token_start : Int <- 0,
            token_end : Int <- 0,
            acc_tokens : List <- new List

        -- Tokenize and construct the <tokens> list
        in {
            line <- ln;

            while token_end < ln.length() loop {
                if ln.substr(token_end, 1) = delimiter then {
                    acc_tokens <- acc_tokens.add(new StringWrapper.init(ln.substr(token_start, token_end - token_start)));
                    token_start <- token_end + 1;
                } else 0 fi;
                token_end <- token_end + 1;
            } pool;

            -- Add last token, when the delimiter is '\n'
            tokens <- acc_tokens.add(new StringWrapper.init(ln.substr(token_start, token_end - token_start)));
            self;
        }
    };

    getTokens() : List {
        tokens
    };

    getFirstToken() : String {
        tokens.hd().getString()
    };

    getSecondToken() : String {
        tokens.tl().hd().getString()
    };

    getThirdToken() : String {
        tokens.tl().tl().hd().getString()
    };

    getFourthToken() : String {
        tokens.tl().tl().tl().hd().getString()
    };
};