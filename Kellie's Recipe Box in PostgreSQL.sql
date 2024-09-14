/*
Kellie's Recipe Box in PostgreSQL - Database design, data manipulation 
*/

/*
Create categories, recipes, ingredients, and recipe_ingredients tables.
*/
-- Ingredient categories
CREATE TABLE categories ( 
	category_id INT PRIMARY KEY,
	category_name VARCHAR(50)
);

-- Recipe list
CREATE TABLE recipes (
	recipe_id INT PRIMARY KEY,
	recipe_name VARCHAR(250),
	instructions TEXT,
    	category_id INT,
	FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Ingredient list
CREATE TABLE ingredients (
	ingredient_id INT PRIMARY KEY,
	ingredient_name VARCHAR(250)
);

-- Connects ingredients to recipes
CREATE TABLE recipe_ingredients (
	FOREIGN KEY (recipe_id) REFERENCES (recipes),
	FOREIGN KEY (ingredient_id) REFERENCES (ingredients)
);


/*
Creating recipe categories and inserting into the categories table. 
*/
INSERT INTO categories (category_id, category_name)
VALUES
	(1, 'Breakfast'),
	(2, 'Lunch'),
	(3, 'Dinner'),
	(4, 'Appetizer'),
	(5, 'Dessert'),
	(6, 'Baked Goods');


/*
Creating a sourdough boule recipe card.
*/
-- Insert ingredients
INSERT INTO ingredients (ingredient_id, ingredient_name)
VALUES
	(1, 'Flour'),
	(2, 'Sourdough Starter'),
	(3, 'Salt');

-- Insert recipe
INSERT INTO recipes (recipe_id, recipe_name, instructions, category_id)
VALUES
	(1, 'Sourdough Boule', 'Mix, rise overnight, bake at 450 for 30 mins.', 6);

-- Insert recipe ingredients 
INSERT INTO recipe_ingredients (recipe_id, ingredient_id)
VALUES
	(1, 1), -- Flour
	(1, 2), -- Sd starter
	(1, 3); -- Salt


/*
Inserting more ingredients for more recipes. 
*/
INSERT INTO ingredients (ingredient_id, ingredient_name)
VALUES
	(4, 'Sugar'),
	(5, 'Brown Sugar'),
	(6, 'Cocoa Powder'),
	(7, 'Pasta'),
	(8, 'Tomato Sauce'),
	(9, 'Ground Beef'),
	(10, 'Chicken Breast'),
	(11, 'Ground Sausage'),
	(12, 'Black Pepper'),
	(13, 'Garlic'),
	(14, 'Onion'),
	(15, 'Butter'),
	(16, 'Olive Oil'),
	(17, 'Milk'),
	(18, 'Rosemary'),
	(19, 'Potatoes'),
	(20, 'Celery'),
	(21, 'Carrots'),
	(22, 'Chocolate Chips'),
	(23, 'Eggs'),
	(24, 'Steak'),
	(25, 'Fish') 

/*
Inserting new recipes, using new ingredients. 
*/
INSERT INTO recipes (recipe_id, recipe_name, instructions, category_id)
VALUES
	(2, 'Spaghetti', 'Cook pasta, warm sauce, and serve.', 3),
	(3, 'Chicken Bake', 'Add vegetables to dish, bake at 350 for 25 mins.', 3),
	(4, 'Cookies', 'Mix ingredients, bake at 350 for 15 mins.', 6),
	(5, 'Steak Dinner', 'Cook steak and potatoes with butter.', 3),
	(6, 'Pancakes', 'Mix ingredients and fry over medium heat.', 1),
	(7, 'Chicken Noodle Soup', 'Simmer vegetables and chicken for 30 mins.', 2),
	(8, 'Breakfast Sausage', 'Press ground sausage into patties, fry.', 1),
	(9, 'Chocolate Cake', 'Mix ingredients, bake at 400 for 30 mins.', 5),
	(10, 'Dinner Rolls', 'Mix ingredients, rise, bake at 425 for 20 mins.', 6),
	(11, 'Vegetable Quiche', 'Mix egg and vegetables, bake at 325 for 15 mins.', 4),
	(12, 'Garlic Mashed Potatoes', 'Boil potatoes, mix with garlic.', 3),
	(13, 'Breakfast Pizza', 'Add egg to crust, bake at 400 for 15 mins.', 1),
	(14, 'Croissants', 'Mix ingredients, bake at 400 for 25 mins.', 6),
	(15, 'Chicken Salad', 'Mix ingredients, serve on bread.', 2)

/*
Connecting new recipes with their ingredients. 
*/
INSERT INTO recipe_ingredients (recipe_id, ingredient_id)
VALUES 
	(2, 7),
	(2, 8),
	(2, 13),
	(3, 10),
	(3, 19),
	(4, 1),
	(4, 4),
	(4, 22),
	(4, 23),
	(5, 24),
	(5, 19),
	(5, 18),
	(5, 15),
	(6, 1),
	(6, 15),
	(6, 23),
	(7, 10),
	(7, 21),
	(7, 20),
	(8, 11),
	(8, 12),
	(9, 1),
	(9, 6),
	(9, 23),
	(10, 1),
	(10, 2),
	(10, 3),
	(10, 4),
	(11, 23),
	(11, 14),
	(11, 20),
	(12, 19),
	(12, 13),
	(12, 15),
	(13, 1),
	(13, 23),
	(14, 1),
	(14, 15),
	(15, 10),
	(15, 20)
	

/*
Let's view which ingredients we'll need to make pancakes and breakfast sausage. 
*/
SELECT 
    r.recipe_name, 
    STRING_AGG(i.ingredient_name,', ') AS ingredients
FROM 
    recipes r

JOIN recipe_ingredients ri 
    ON r.recipe_id = ri.recipe_id

JOIN ingredients i 
    ON ri.ingredient_id = i.ingredient_id

WHERE r.recipe_id IN (6, 8)

GROUP BY 
    r.recipe_name;

/* Result:
+-------------------+-----------------------------+
| recipe_name       | ingredients                 |
+-------------------+-----------------------------+
| Pancakes          | Flour, Butter, Eggs         |
| Breakfast Sausage | Ground Sausage, Black Pepper|
+-------------------+-----------------------------+
*/


/*
Now I'll display all dinner recipes and their instructions.
*/
SELECT 
    r.recipe_name,
    STRING_AGG(i.ingredient_name, ', ') AS ingredients,
    r.instructions
    
FROM recipes r
    
JOIN recipe_ingredients ri 
    ON r.recipe_id = ri.recipe_id
    
JOIN ingredients i 
    ON ri.ingredient_id = i.ingredient_id

WHERE 
    r.category_id = 3

GROUP BY 
    r.recipe_name,
    instructions;

/* Result:
+------------------------+-------------------------------+--------------------------------------------------+
| recipe_name            | ingredients                   | instructions                                     |
+------------------------+-------------------------------+--------------------------------------------------+
| Chicken Bake           | Chicken Breast, Potatoes      | Add vegetables to dish, bake at 350 for 25 mins. |
| Garlic Mashed Potatoes | Butter, Garlic, Potatoes      | Boil potatoes, mix with garlic.                  | 
| Spaghetti              | Pasta, Tomato Sauce, Garlic   | Cook pasta, warm sauce, and serve.               |
| Steak Dinner           | Butter, Rosemary, Potatoes, Steak | Cook steak and potatoes with butter.         |
+------------------------+-------------------------------+--------------------------------------------------+
*/


/*
Finally, I'll list all recipes that contain eggs.
*/
SELECT 
    r.recipe_name,
    i.ingredient_name AS "Contains Eggs"
    
FROM recipes r
    
JOIN recipe_ingredients ri 
    ON r.recipe_id = ri.recipe_id
    
JOIN ingredients i 
    ON ri.ingredient_id = i.ingredient_id

WHERE 
    i.ingredient_name = 'Eggs'
    
GROUP BY 
    r.recipe_name,
    i.ingredient_name;

/* Result:
+--------------------+--------------+
| recipe_name        | Contains Eggs|
+--------------------+--------------+
| Breakfast Pizza    | Eggs         |
| Chocolate Cake     | Eggs         |
| Cookies            | Eggs         |
| Pancakes           | Eggs         |
| Vegetable Quiche   | Eggs         |
+--------------------+--------------+
*/
