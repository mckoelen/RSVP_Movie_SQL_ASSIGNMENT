USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) from director_mapping;
select count(*) from genre; 
select count(*) from movie; 
select count(*) from names; 
select count(*) from ratings; 
select count(*) from role_mapping; 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select sum(case when id is null then 1 else 0 end) as id_nulls,
		sum(case when title is null then 1 else 0 end) as title_nulls,
		sum(case when date_published is null then 1 else 0 end) as date_published_nulls,
        sum(case when duration is null then 1 else 0 end) as duration_nulls,
        sum(case when country is null then 1 else 0 end) as country_nulls,
		sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_nulls,
        sum(case when Languages is null then 1 else 0 end) as Languages_nulls,
        sum(case when production_company is null then 1 else 0 end) as production_company_nulls
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+




Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, COUNT(title) AS number_of_movies
FROM movie
GROUP BY year;


SELECT month(date_published) AS month  , COUNT(title) AS number_of_movies
FROM movie
GROUP BY month
ORDER BY month ASC;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT year, count(title) as number_of_movies FROM movie
WHERE (country LIKE "%USA%" OR country LIKE "%India%") AND year="2019";



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT (genre) AS Genre_list
FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT DISTINCT (genre) AS Genre_list , COUNT(genre) as count_gener
FROM genre
GROUP BY Genre_list
ORDER BY count_gener DESC;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre AS 
(
SELECT movie_id AS Movie_list, count(genre) as genre_count
FROM genre 
GROUP BY Movie_list
having genre_count= 1
)
select count(Movie_list)
FROM single_genre;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

 

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre , ROUND (AVG(duration),2) AS avg_duration
FROM movie as m
INNER JOIN genre as g
ON m.id = g.movie_id
GROUP BY genre 
order by avg_duration DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


with ranking as 
(
SELECT genre , count(movie_id) as movie_count , rank () over (order by count(movie_id) DESC) as genre_rank 
from genre 
group by genre
order by genre_rank 
) 
select * from ranking;




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:



-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating , MAX(avg_rating) AS max_avg_rating ,
	MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating , MAX(median_rating) AS min_median_rating
FROM ratings; 


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


with avg_rating as 
(
select title, avg_rating , dense_rank () over (order by avg_rating DESC) as movie_rank 
from movie as m 
inner join ratings as r 
on m.id = r.movie_id
group by title 
order by  avg_rating DESC 
 )
select *
from avg_rating ;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, count(movie_id) AS movie_count FROM ratings
GROUP BY median_rating
ORDER BY median_rating;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
       Count(id) AS movie_count,
      dense_rank()
         OVER(
           ORDER BY Count(id) DESC) AS prod_company_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company
ORDER  BY movie_count DESC;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, count(title) as movie_count 
from genre as g 
inner join movie as m 
on m.id = g.movie_id
inner join ratings as r 
on r.movie_id= m.id
where month(date_published)=3 and year(date_published) = 2017 and country ='USA' and total_votes > '1000'
group BY genre;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title , avg_rating ,group_concat(genre) 
from genre as g 
inner join movie as m 
on m.id = g.movie_id
inner join ratings as r 
on r.movie_id= m.id
where title regexp '^The' and avg_rating > 8
GROUP BY title
ORDER BY avg_rating ASC;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT title , date_published 
from movie as m
inner join ratings as r 
on m.id = r.movie_id
where date_published between "2018-04-01" and "2019-04-01" and median_rating = 8 
group by title
ORDER BY date_published; 



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below: 

SELECT languages, total_votes 
FROM movie AS m
INNER JOIN ratings as r
 ON m.id = r.movie_id
WHERE languages = "German" or languages = "Italian"
GROUP BY languages ;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select sum(case when name is null then 1 else 0 end) as name_nulls,
		sum(case when height is null then 1 else 0 end) as height_nulls,
		sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
        sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_director
     AS (SELECT NAME AS director_name,
                Count(dr.movie_id) AS movie_count,
                Row_number()
                  OVER(
                    ORDER BY Count(dr.movie_id) DESC ) AS director_rank
         FROM   director_mapping AS dr
                INNER JOIN names AS n
                        ON dr.name_id = n.id
                INNER JOIN ratings AS r
                        ON dr.movie_id = r.movie_id
         WHERE  avg_rating > 8
         GROUP  BY director_name)
SELECT director_name,
       movie_count
FROM   top_director
WHERE  director_rank <= 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	n.name AS actor_name,
    COUNT(n.id) as movie_count , rank()
                  OVER(ORDER BY COUNT(n.id) DESC ) movie_rank
FROM role_mapping AS rm
INNER JOIN names AS n
ON rm.name_id = n.id
INNER JOIN movie AS m
ON m.id = rm.movie_id
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE LOWER(category) = 'actor' and median_rating >=8 
GROUP BY name 
ORDER BY movie_count DESC
limit 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+ */
-- Type your code below:

SELECT production_company , sum(total_votes) AS vote_count, rank()
                  OVER(ORDER BY sum(total_votes)DESC ) prod_comp_rank
FROM movie AS m
INNER JOIN ratings as r 
ON m.id = r.movie_id
GROUP BY production_company
order by vote_count DESC
limit 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name AS actor_name , total_votes AS total_votes , count(m.id) AS movie_count , avg_rating as actor_avg_rating,
		row_number() over (ORDER BY avg_rating DESC) AS actor_rank
FROM movie AS m 
 INNER JOIN ratings as r 
 on m.id = r.movie_id
 INNER JOIN role_mapping AS rm 
 ON rm.movie_id = r.movie_id 
 inner join names as n 
 on n.id = rm.name_id
 WHERE UPPER(country) ='INDIA'
group BY actor_name
HAVING count(rm.movie_id) >=5;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS Actress_name ,  total_votes , count(m.id) AS movie_count , avg_rating as actress_avg_rating,
		row_number() over (ORDER BY total_votes DESC) AS actress_rank
FROM movie AS m 
 INNER JOIN ratings as r 
 on m.id = r.movie_id
 INNER JOIN role_mapping AS rm 
 ON rm.movie_id = r.movie_id 
 inner join names as n 
 on n.id = rm.name_id
 WHERE UPPER(country) ='INDIA' and LOWER(category) = 'actress' and LOWER(languages) = 'hindi'
group BY Actress_name
HAVING count(rm.movie_id) >=3;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH categoried_rating AS 
( 
SELECT title , genre , avg_rating 
from genre AS g 
INNER JOIN movie AS m 
ON m.id = g.movie_id
INNER JOIN ratings as r 
ON r.movie_id = m.id
where LOWER(genre) = 'thriller'
)
select title, avg_rating ,case 
			when avg_rating > 8 then 'Superhit movies'
            when avg_rating between 7 and 8 then 'Hit movies'
            when avg_rating between 5 and 7 then 'One-time-watch movies'
            ELSE 'flop movie' 
            END AS rating_new
from categoried_rating
Group BY title
order BY avg_rating DESC; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre, AVG(duration) AS avg_duration, 
       ROUND(SUM(AVG(duration)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING),2) AS running_total_duration,
	   ROUND(AVG(AVG(duration)) OVER (ORDER BY genre ROWS 15 PRECEDING),2) AS moving_avg_duration
FROM movie as m
INNER JOIN genre AS g 
ON m.id = g.movie_id
GROUP BY genre;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_three_genres AS 
(
SELECT genre, COUNT(movie_id) AS no_of_movies
FROM genre
GROUP BY genre
ORDER BY no_of_movies DESC
LIMIT 3
)
,top_five_movies AS
(
SELECT g.genre, year, title AS movie_name, worlwide_gross_income, 
       DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie AS m
		INNER JOIN genre AS g 
        ON m.id = g.movie_id
		INNER JOIN top_three_genres AS tg 
        ON g.genre = tg.genre
)
SELECT * FROM top_five_movies
WHERE movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT upper(production_company) as production_company, count(id) as movie_count , row_number() OVER (ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie as m 
INNER JOIN ratings as r 
on r.movie_id = m.id
WHERE production_company is not NULL and median_rating >= 8 and POSITION(',' IN languages)>0
group by production_company
ORDER BY movie_count DESC
limit 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

Select (n.name) as actress_name , total_votes , count(m.id) as movie_counts , avg_rating AS actress_avg_rating, 
		row_number () Over (ORDER BY avg_rating DESC ) as actress_rank
FROM movie as m 
inner join role_mapping as rm 
on rm.movie_id = m.id 
INNER JOIN ratings as r 
on r.movie_id = m.id
INNER JOIN names as n 
on rm.name_id=n.id
INNER JOIN genre as g 
ON g.movie_id=m.id
where avg_rating >8 and LOWER(category) = 'actress' and genre = 'drama'
GROUP BY n.name
ORDER BY actress_avg_rating DESC
limit 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_details AS
(
SELECT name_id AS Director_id, name AS Director_name, dm.movie_id, duration,
	   avg_rating AS Avg_rating, total_votes AS Total_votes, avg_rating * total_votes AS Rating_count,
	   date_published,
       LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY date_published, name) AS Next_publish_date
FROM director_mapping AS dm
		INNER JOIN names AS n 
        ON dm.name_id = n.id
		INNER JOIN movie AS m 
        ON dm.movie_id = m.id 
		INNER JOIN ratings AS r 
        ON m.id = r.movie_id
)
SELECT Director_id, Director_name,
        COUNT(movie_id) AS Number_of_movies,
        CAST(SUM(rating_count)/SUM(total_votes)AS DECIMAL(4,2)) AS Avg_rating,
        ROUND(SUM(DATEDIFF(Next_publish_date, date_published))/(COUNT(movie_id)-1)) AS Avg_inter_movie_days,
        SUM(total_votes) AS Total_votes, MIN(avg_rating) AS Min_rating, MAX(avg_Rating) AS Max_rating,
        SUM(duration) AS Total_duration
FROM director_details
GROUP BY Director_id
ORDER BY Number_of_movies DESC
LIMIT 9;


