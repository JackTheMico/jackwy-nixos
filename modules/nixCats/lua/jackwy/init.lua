require("lze").register_handlers {
    require("nixCatsUtils.lzUtils").for_cat,
    require("lzextras").lsp,
}

require('lze').load {
    { import = "jackwy.plugins" },
    { import = "jackwy.lsps" },
    { import = "jackwy.format" },
}
