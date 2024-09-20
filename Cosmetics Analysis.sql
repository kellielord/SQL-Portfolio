/*
Popular Cosmetics 2024 Anaylsis in PostgreSQL
Dataset: https://www.kaggle.com/datasets/waqi786/most-used-beauty-cosmetics-products-in-the-world
*/

/*
First, we have to create the table in PostgreSQL and upload the data.
*/

CREATE TABLE popular_cosmetics_2024 (
    Product_Name VARCHAR(255),
    Brand VARCHAR(255),
    Category VARCHAR(255),
    Usage_Frequency INTEGER,
    Price_USD NUMERIC(10, 2),
    Rating NUMERIC(3, 2),
    Number_of_Reviews INTEGER,
    Product_Size VARCHAR(50),
    Skin_Type VARCHAR(255),
    Gender_Target VARCHAR(50),
    Packaging_Type VARCHAR(255),
    Main_Ingredient VARCHAR(255),
    Cruelty_Free BOOLEAN,
    Country_of_Origin VARCHAR(255)
);


/*
NOTE: This dataset required extensive cleaning due to miscategorized products.
All 24 categories were updated using variations of the following statement:
*/

UPDATE cosmetics
SET Category = 'category'
WHERE Product_Name ILIKE '%product_name%' AND Category != 'category';


/*
Let's identify the top-selling products based on rating and number of reviews:
*/

SELECT
    brand,
    product_name,
    number_of_reviews,
    rating
FROM
    cosmetics

ORDER BY 
    rating DESC, 
    number_of_reviews DESC;


/*
Determining the average, max, and min price for each product category:
*/

SELECT
    category,
    ROUND(avg(price_usd),2) AS avg_price,
    MAX(price_usd) AS max_price,
    MIN(price_usd) AS min_price
     
FROM
    cosmetics

GROUP BY
    category

ORDER BY 
    avg_price DESC;


/*
Finding the price range for products based on their intended skin type:
*/

SELECT
    skin_type,
    ROUND(avg(price_usd),2) AS avg_price,
    MAX(price_usd) AS max_price,
    MIN(price_usd) AS min_price
     
FROM
    cosmetics

GROUP BY
    skin_type
ORDER BY 
    avg_price;


/*
Average price range by targeted gender of product: 
*/

SELECT
    gender_target,
    ROUND(avg(price_usd),2) AS avg_price,
    MAX(price_usd) AS max_price,
    MIN(price_usd) AS min_price
     
FROM
    cosmetics

GROUP BY
    gender_target
ORDER BY 
    avg_price;

/*
Average product rating by targeted gender of product: 
*/

SELECT
    gender_target,
    ROUND(avg(rating), 3) AS avg_rating
     
FROM
    cosmetics

GROUP BY
    gender_target
ORDER BY 
    avg_rating;


/*
Counting the number of cruelty-free products by brand:
*/

SELECT
    brand,
    COUNT(product_name) AS cruelty_free_true
     
FROM
    cosmetics

WHERE cruelty_free = TRUE

GROUP BY
    brand

order by 
    cruelty_free_true DESC;


/*
Determining the most popular main ingredients by category:
*/

WITH ingredients AS(
    SELECT 
        category,
        main_ingredient,
        COUNT(main_ingredient) AS ingredient_count
    FROM 
        cosmetics
    
    GROUP BY
        category,
        main_ingredient
),
ingredients_ranked AS(
    SELECT
        category,
        main_ingredient,
        ingredient_count,
        RANK() OVER(PARTITION BY category ORDER BY ingredient_count DESC)
    FROM
        ingredients
)

SELECT
    category,
    main_ingredient,
    ingredient_count
FROM 
    ingredients_ranked

WHERE
    rank = 1


/*
Comparing product size with average price:
*/

SELECT
    product_size,
    ROUND(AVG(price_usd),2) AS avg_price,
    MIN(price_usd) AS min_price,
    MAX(price_usd) AS max_price
FROM
    cosmetics
GROUP BY
    product_size
ORDER BY
    product_size


/*
Average product ratings based on country of origin:
*/

SELECT
    ROUND(AVG(rating),3) AS avg_rating,
    country_of_origin
FROM
    cosmetics
GROUP BY
    country_of_origin
ORDER BY
    avg_rating DESC;
