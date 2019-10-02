class Food {
  String name;
  double price;
  double rate;
  int rateCount;
  String image;
  FoodTypes foodType;
  Food({this.name, this.price, this.image, this.rate, this.rateCount, this.foodType});
}

enum FoodTypes {
  Salad,
  All,
  Pizza,
  Asian,
  Burger,
  Dessert,
}

List<Food> foods = [
  Food(
    name: 'Vegetable and Poached Egg',
    price: 15,
    rate: 3.0,
    rateCount: 15,
    image: 'https://keyassets-p2.timeincuk.net/wp/prod/wp-content/uploads/sites/53/2014/05/Poached-egg-and-bacon-salad-recipe-920x605.jpg',
    foodType: FoodTypes.Salad,
  ),
  Food(
    name: 'Avocado Salad With Mayonoise Soy Sauce',
    price: 12.49,
    rate: 2,
    rateCount: 25,
    image: 'https://natashaskitchen.com/wp-content/uploads/2015/06/Cucumber-tomato-avocado-salad-8.jpg',
    foodType: FoodTypes.Salad,
  ),
  Food(
    name: 'Pancake With Orange Sauce',
    price: 9.99,
    rate: 3,
    rateCount: 67,
    image: 'https://iowagirleats.com/wp-content/uploads/2013/01/OrangePancakes_02_mini.jpg',
    foodType: FoodTypes.Salad,
  ),
  Food(
    name: 'Vegetables Salad',
    price: 7.49,
    rate: 4,
    rateCount: 29,
    image: 'https://iowagirleats.com/wp-content/uploads/2016/06/Marinated-Vegetable-Salad-iowagirleats-03.jpg',
    foodType: FoodTypes.Salad,
  ),
  Food(
    name: 'Pineapple Pizza',
    price: 22.99,
    rate: 5,
    rateCount: 102,
    image: 'https://verytasty.us/assets/uploads/2018/07/shutterstock_84904861-750x500.jpg',
    foodType: FoodTypes.Pizza,
  ),
];
