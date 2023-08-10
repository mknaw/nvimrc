local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
--local node = ls.snippet_node
local text = ls.text_node
local i = ls.insert_node
--local insert = ls.insert_node
--local func = ls.function_node
--local choice = ls.choice_node
--local dynamicn = ls.dynamic_node

--local date = function() return {os.date("%Y-%m-%d")} end

ls.add_snippets(nil, {
    all = {
        --snip({
        --    trig = "date",
        --    namr = "Date",
        --    dscr = "Date in the form of YYYY-MM-DD",
        --}, {
        --    func(date, {}),
        --}),
    },
    python = {
        snip({
            trig = "akw",
            name = "args kwargs",
            dscr = "*args, **kwargs",
        }, {
            text("*args, **kwargs"),
        }),
        snip({
            trig = "usefix",
            name = "use fixtures",
            dscr = "decorate with @pytest.mark.usefixtures",
        }, {
            text("@pytest.mark.usefixtures("),
            -- TODO could improve by surrounding with quotes...
            i(1),
            text(")"),
        }),
    },
    haskell = {
        snip({
            trig = "und",
            name = "undefined",
            dscr = "undefined",
        }, {
            text("undefined"),
        }),

    }
})
