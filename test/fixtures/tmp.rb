
  add_tests("call_unary_neg",
            "Ruby"         => "-2**31",
            "RawParseTree" => [:call,
                               [:call, [:lit, 2], :**, [:array, [:lit, 31]]],
                               :-@],
            "ParseTree"    => s(:call,
                                s(:call,
                                  s(:lit, 2),
                                  :**,
                                  s(:arglist, s(:lit, 31))),
                                :-@, s(:arglist)),
            "Ruby2Ruby"    => "-(2 ** 31)")