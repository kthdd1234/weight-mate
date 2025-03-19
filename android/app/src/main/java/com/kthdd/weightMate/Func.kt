package com.kthdd.weightMate

val colorItemList = arrayOf<ColorItem>(
    ColorItem("빨간색", R.color.red_400),
    ColorItem("파란색", R.color.blue_400),
    ColorItem("남색", R.color.indigo_400),
    ColorItem("녹색", R.color.green_400),
    ColorItem("청록색", R.color.teal_400),
    ColorItem("핑크색", R.color.pink_400),
    ColorItem("갈색", R.color.brown_400),
    ColorItem("주황색", R.color.orange_400),
    ColorItem("보라색", R.color.purple_400),
    ColorItem("청회색", R.color.blue_grey_400),
    ColorItem("검정색", R.color.black_400),
)


fun getColorItem(name: String?): ColorItem {
    var colorItem = ColorItem("빨간색", R.color.red_400)

    for (item in colorItemList) {
        if(item.name == name) {
            colorItem = item;
        }
    }

    return colorItem
}