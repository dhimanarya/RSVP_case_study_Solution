USE imdb;
-- Problem Introduction
/*RSVP Movies is an Indian film production company which has produced many super-hit movies. They have usually released movies for the Indian audience 
but for their next project, they are planning to release a movie for the global audience in 2022.
The production company wants to plan their every move analytically based on data and have approached you for help with this new project. You have been 
provided with the data of the movies that have been released in the past three years. You have to analyse the data set and draw meaningful insights 
that can help them start their new project. 

 */

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows AS Total_no_of_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
with null_count as (select count(*) as total_count, count(id) as id_null,
 count(title) as title_null, count(year) as year_null,count(date_published) as date_published_null, count(duration) as duration_null,
 count(country) as country_null, count(worlwide_gross_income) as worldwide_grossing_null, count(languages) as lanuage_null , 
 count(production_company) as production_companay_null from movie)
 select (total_count-id_null) as missing_id,(total_count-title_null) missing_title,(total_count-year_null) missing_year,(total_count-date_published_null)
  missing_published_date,(total_count-duration_null) missing_durations,
 (total_count-country_null) missing_country_name,(total_count-worldwide_grossing_null) missing_earnings,(total_count-lanuage_null)
  missing_movie_language,(total_count-production_companay_null) as missing_production_name from null_count;
/* only few missing in Country while there is lot of missing in worldwide_grossing, language and production of movie table
missing_country_name missing_earnings missing_movie_language missing_production_name
	20						3724				194						528

*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+*/
select  m.year as Year, count(distinct id) as number_of_movies from movie as m group by m.year;
/*Year, number_of_movies
2017	3052
2018	2944
2019	2001*/
/*
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select  month(date_published) as Month, count(id) as number_of_movies from movie as m 
group by month(date_published) 
order by month(date_published);
/* top 3 month wiht highest movie reselese are march(824), sept(809), and jan(804)
while min in dec (438), july(493), june(580) are month wiht least movies*/
/*
Month, number_of_movies
1	804
2	640
3	824
4	680
5	625
6	580
7	493
8	678
9	809
10	801
11	625
12	438
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select country, count(id) number_of_movies from movie
where year =2019 and (country ='India' or country ='USA'  )
group by country
order by country;
/*
country, number_of_movies
India		295
USA			592

*/
-- I was unable to group country using like function





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre
order by genre;
/*13  genre as follows: Action
Adventure
Comedy
Crime
Drama
Family
Fantasy
Horror
Mystery
Others
Romance
Sci-Fi
Thriller*/









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre, count(movie_id),year from genre as g join movie as m on g.movie_id =m.id
group by genre,year
order by count(movie_id) desc
limit 3;
-- question was intitally asking for number of movies in last year the it asked for over that why i split movie into years
/*	genre count(movie_id) Year
	Drama	1664	2017
	Drama	1543	2018
	Drama	1078	2019

*/ 
-- Drama has the maximum number of movies in 2019









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with genre_one as (SELECT 
movie_id,COUNT(genre) AS genre_count
FROM genre AS g
GROUP BY g.movie_id
HAVING COUNT( genre) =1)
select count(*) from genre_one;
/*such movies are 3289 in count */






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
select genre,round(avg(duration),2) from genre join movie on genre.movie_id = movie.id
group by genre
order by avg(duration) desc;

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/*
genre		avg(duration)
Action		112.88
Romance		109.53
Crime		107.05
Drama		106.77
Fantasy		105.14
Comedy		102.62
Adventure	101.87
Mystery		101.80
Thriller	101.58
Family		100.97
Others		100.16
Sci-Fi		97.94
Horror		92.72

*/
-- action genre has maximum average duration followed by romamce and then crime








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
with top_10 as (select genre,count(distinct movie_id)as number_of_movies, rank() over ( order by count(distinct movie_id)desc ) as Ranking
from genre
group by genre) 
select * 
from top_10
where genre ='Thriller'
;
/*
genr	 number_of_movies Ranking
Thriller	1484			3

*/
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:










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
select min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes, max(total_votes) as max_total_votes,
 min(median_rating) as min_median_rating,
 max(median_rating) as max_median_rating from ratings;
/*
all things are in the range and as ideal datatype.  no column is out of ranage
*/




    

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
select title, avg_rating, dense_rank() over ( order by avg_rating desc) as ranking from ratings r join movie m on m.id=r.movie_id limit 10;
/*
title 						avg_rating ranking
Kirket							10.0	1
Love in Kilnerry				10.0	1
Gini Helida Kathe				9.8		2
Runam							9.7		3
Fan								9.6		4
Android Kunjappan Version 5.25	9.6		4
Yeh Suhaagraat Impossible		9.5		5
Safe							9.5		5
The Brighton Miracle			9.5		5
Shibu							9.4		6
Our Little Haven				9.4		6
Zana							9.4		6
Family of Thakurganj			9.4		6
Ananthu V/S Nusrath				9.4		6
Eghantham						9.3		7
Wheels							9.3		7
Turnover						9.2		8
Digbhayam						9.2		8
Tõde ja õigus					9.2		8
Ekvtime: Man of God				9.2		8
Leera the Soulmate				9.2		8
AA BB KK						9.2		8
Peranbu							9.2		8
Dokyala Shot					9.2		8
Ardaas Karaan					9.2		8
Kuasha jakhon					9.1		9
Oththa Seruppu Size 7			9.1		9
Adutha Chodyam					9.1		9
The Colour of Darkness			9.1		9
Aloko Udapadi					9.1		9
C/o Kancharapalem				9.1		9
Nagarkirtan						9.1		9
Jelita Sejuba: Mencintai 		9.1		9
Kesatria Negara
Shindisi						9.0		10
Officer Arjun Singh IPS			9.0		10
Oskars Amerika					9.0		10
Delaware Shore					9.0		10
Abstruse						9.0		10
National Theatre Live: Angels 
in America Part Two - Perestroika9.0	10
Innocent						9.0		10

*/






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
select median_rating, count(movie_id) as movie_count from ratings
group by median_rating
order by median_rating;
/* order by movie count
median_rating, movie_count
	7				2257
	6				1975
	8				1030
	5				985
	4				479
	9				429
	10				346
	3				283
	2				119
	1				94
maximun number of movies are with rating 7 
*/








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
select production_company, count(id)as  movie_count, dense_rank() over ( order by count(id) desc) as prod_company_rank from movie join ratings 
on movie.id = ratings.movie_id
where avg_rating>8 and production_company is not null
group by production_company;
/* 
production_company, movie_count, prod_company_rank
# production_company	movie_count	prod_company_rank
Dream Warrior Pictures		3				1
National Theatre Live		3				1

*/
/*Dream Warrior Pictures & National Theatre Live are  the top production house that produces hit movies but there is missing data
so there is a tie in between them*/








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
SELECT 
    genre, COUNT(movie_id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r USING (movie_id)
WHERE
    m.year = 2017
        AND MONTH(date_published) = 3
        AND country LIKE '%USA%'
        AND r.total_votes > 1000
GROUP BY genre
order by COUNT(movie_id) desc ;
/*
genre, movie_count
	genre	movie_count
	Drama		24
	Comedy		9
	Action		8
	Thriller	8
	Sci-Fi		7
	Crime		6
	Horror		6
	Mystery		4
	Romance		4
	Fantasy		3
	Adventure	3
	Family		1
*/


/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:









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

select title, avg_rating , genre from movie m join ratings r on m.id =r.movie_id join genre using(movie_id)
where title like 'the%' and avg_rating>8;
/*
title			 					avg_rating 	genre
The Brighton Miracle					9.5		Drama
The Colour of Darkness					9.1		Drama
The Blue Elephant 	2					8.8		Drama
The Blue Elephant 	2					8.8		Horror
The Blue Elephant 	2					8.8		Mystery
The Irishman							8.7		Crime
The Irishman							8.7		Drama
The Mystery of Godliness: The Sequel	8.5		Drama
The Gambinos							8.4		Crime
The Gambinos							8.4		Drama
Theeran Adhigaaram Ondru				8.3		Action
Theeran Adhigaaram Ondru				8.3		Crime
Theeran Adhigaaram Ondru				8.3		Thriller
The King and I							8.2		Drama
The King and I							8.2		Romance
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(m.id)
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
  AND r.median_rating = 8;
-- number of movies wiht median rating 8 is 361


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
with german_votes as (select sum(total_votes) as total_votes_german_mov from ratings r
 join movie m on r.movie_id = m.id where country ='Germany'),
italy_votes as (select sum(total_votes) as total_votes_italy_mov from ratings r
 join movie m on r.movie_id = m.id where country ='Italy')
select total_votes_german_mov ,total_votes_italy_mov from german_votes , italy_votes ;
/*total_votes_german_mov, total_votes_italy_mov
		106710					77965

*/
-- yes as german movies got more votes then italian movies







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
select sum(case when n.name is null then 1 else 0 end) as names_null_count ,
sum(case when n.height is null then 1 else 0 end) as height_null_count,
sum(case when n.date_of_birth is null then 1 else 0 end) as dob_null_count,
sum(case when n.known_for_movies is null then 1 else 0 end) as know_null_count
from names as n;
/*
names_null_count height_null_count dob_null_count, know_null_count
		0				17335				13431		15226

*/






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an 
-- average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

select name as director_name, count(genre.movie_id) as movie_count, ROW_NUMBER() OVER(ORDER BY COUNT(genre.movie_id) DESC) AS director_ranking
from names join director_mapping 
on names.id= director_mapping.name_id 
join genre on director_mapping.movie_id = genre.movie_id join ratings on genre.movie_id=ratings
.movie_id
where avg_rating>8
group by name
order by  count(genre.movie_id) desc
limit 3;
/* top 3 directors are 
	director_name  movie_count
	Anthony Russo		6
	Joe Russo			6
	James Mangold		5
*/
#check 
/* Output format:


+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:









/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
select name as actor_name, count(ratings.movie_id) as movie_count
from role_mapping join names on role_mapping.name_id = names.id
join ratings on role_mapping.movie_id=ratings.movie_id
where median_rating >=8
group by name
order by count(ratings.movie_id) desc
limit 2;
/*
actor_name  	movie_count
Mammootty			8
Mohanlal			5

*/
/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:








/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/
-- Q21. Which are the top three production houses based on the number of votes received by their movies?
select production_company , sum(total_votes) as vote_count, dense_rank() 
over ( order by sum(ratings.total_votes) desc) as prod_comp_rank
from movie m join ratings on m.id = ratings.movie_id
group by production_company
limit 3;
/*
production_company		vote_count		prod_comp_rank
Marvel Studios			2656967				1
Twentieth Century Fox	2411163				2
Warner Bros.			2396057				3

*/


/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
select n.name as actor_name,sum(ratings.total_votes) as total_votes,count(role_mapping.movie_id) as movie_count, round(SUM(avg_rating*total_votes)/SUM(total_votes) ,2) as 
actor_avg_rating,  rank() 
over (order by SUM(avg_rating*total_votes)/SUM(total_votes) desc) as actor_rank
from names as n join role_mapping on n.id=role_mapping.name_id join ratings
 on role_mapping.movie_id=ratings.movie_id join movie on ratings.movie_id=movie.id
 where movie.country like '%India%' and role_mapping.category='actor'
group by  name
having  count(role_mapping.movie_id) >4
order by SUM(avg_rating*total_votes)/SUM(total_votes) 
desc , sum(ratings.total_votes) desc


limit 1;

/*
	actor_name			total_votes 	movie_count	 	actor_avg_rating 		actor_rank
Vijay Sethupathi			23114				5				8.42				1

*/


/* Output format:
+---------------+-------------------+------


---------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- code check







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
select n.name as actress_name,sum(ratings.total_votes) as total_votes,count(role_mapping.movie_id) as movie_count, round(SUM(avg_rating*total_votes)/SUM(total_votes),2) as 
actor_avg_rating,  rank() 
over (order by SUM(avg_rating*total_votes)/SUM(total_votes) desc) as actress_rank
from names as n join role_mapping on n.id=role_mapping.name_id join ratings
 on role_mapping.movie_id=ratings.movie_id join movie on ratings.movie_id=movie.id
 where movie.country like '%India%' and role_mapping.category='actress' and movie.languages like '%hindi%'
group by  name
having  count(role_mapping.movie_id) >2
order by SUM(avg_rating*total_votes)/SUM(total_votes) 
desc , sum(ratings.total_votes) desc
limit 5;
/*
	actor_name 			total_votes 		movie_count 	actor_avg_rating 	actress_rank
Taapsee Pannu				18061				3				7.74				1
Kriti Sanon					21967				3				7.05				2
Divya Dutta					8579				3				6.88				3
Shraddha Kapoor				26779				3				6.63				4
Kriti Kharbanda				2549				3				4.80				5

*/



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









/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select title, case 
when avg_rating>8 then 'Superhit movies'
when avg_rating between 7 and 8 then 'Hit movies'
when avg_rating between 5 and 7  then 'One-time-watch movies'
else 'Flop movies'
end as category
from ratings join genre using(movie_id) join movie on movie.id=genre.movie_id
where genre.genre='Thriller';





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
-- code to check range interval to put 
select genre,count(movie_id) from movie inner join genre on movie.id=genre.movie_id
group by genre
order by count(movie_id) desc;
-- as moving average interval is not given so based on others having 100 count using above code
	select genre ,round( avg(duration),2) as avg_duration
	, sum(avg(duration)) over (order  by genre.genre rows  unbounded preceding ) as running_total_duration,
   avg(avg(duration)) over (order  by genre.genre rows  20 preceding ) as moving_avg_duration
	from genre join movie on movie.id=genre.movie_id
    group by genre;
/*
genre	 	avg_duration	 running_total_duration	 moving_avg_duration
Action	 	112.8829			112.88					112.88290000
Adventure	101.8714			214.75					107.37715000
Comedy		102.6227			317.38					105.79233333
Crime		107.0517			424.43					106.10717500
Drama		106.7746			531.20					106.24066000
Family		100.9669			632.17					105.36170000
Fantasy		105.1404			737.31					105.33008571
Horror		92.7243				830.03					103.75436250
Mystery		101.8000			931.84					103.53721111
Others		100.1600			1031.99					103.19949000
Romance		109.5342			1141.53					103.77537273
Sci-Fi		97.9413				1239.47					103.28920000
Thriller	101.5761			1341.05					103.15742308
*/
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









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
-- Data values have some error with them leading to wrong data sorting. Specially values starting with INR.

WITH top_3_genre AS (
    SELECT genre 
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
), edit AS (
    SELECT 
        *, 
        CASE 
            WHEN worlwide_gross_income LIKE '$%' THEN CAST(REPLACE(worlwide_gross_income, '$ ', '') AS DECIMAL(15))
            ELSE CAST(REPLACE(worlwide_gross_income, 'INR%','') AS DECIMAL(15)) * 0.012
        END AS numerical_worlwide_gross_income
    FROM movie AS m
), high_gross AS (
    SELECT
        title AS movie_name, id as my_key, genre,
        year, numerical_worlwide_gross_income,
        DENSE_RANK() OVER (PARTITION BY m.year ORDER BY numerical_worlwide_gross_income DESC) AS movie_rank
    FROM genre as g
    JOIN edit AS e ON g.movie_id = e.id
    WHERE g.genre IN (SELECT genre FROM top_3_genre)
)

SELECT
    genre,
    year,
    movie_name,
    numerical_worlwide_gross_income,
    DENSE_RANK() OVER(PARTITION BY year ORDER BY numerical_worlwide_gross_income DESC, movie_name) AS movie_rank
FROM high_gross 
WHERE movie_rank <= 5
ORDER BY year, numerical_worlwide_gross_income DESC, movie_rank;



/*
genre, 	year, movie_name, worldwide_gross_income, movie_rank
Thriller	2017	The Fate of the Furious			1236005118.000	1
Comedy		2017	Despicable Me 3					1034799409.000	2
Comedy		2017	Jumanji: Welcome to the Jungle	962102237.000	3
Drama		2017	Zhan lang II					870325439.000	4
Thriller	2017	Zhan lang II					870325439.000	4
Comedy		2017	Guardians of the Galaxy Vol. 2	863756051.000	5
Drama		2018	Bohemian Rhapsody				903655259.000	1
Thriller	2018	Venom							856085151.000	2
Thriller	2018	Mission: Impossible - Fallout	791115104.000	3
Comedy		2018	Deadpool 2						785046920.000	4
Comedy		2018	Ant-Man and the Wasp			622674139.000	5
Drama		2019	Avengers: Endgame				2797800564.000	1
Drama		2019	The Lion King					1655156910.000	2
Comedy		2019	Toy Story 4						1073168585.000	3
Drama		2019	Joker							995064593.000	4
Thriller	2019	Joker							995064593.000	4
Thriller	2019	Ne Zha zhi mo tong jiang shi	700547754.000	5

*/


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










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
select production_company, if( production_company is not null,count(id) ,0) as movie_count, rank() over ( order by  count(id) desc ) as prod_comp_rank
 from movie  join ratings on movie.id = ratings.movie_id
where median_rating >= 8 and production_company is not null  and languages like '%,%'
group by production_company
order by  count(id) desc
limit 2 ;
/*
production_company, movie_count, prod_comp_rank
Star Cinema			   		7 			1
Twentieth Century Fox 		4 			2

*/

/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?

select name, sum(total_votes), count(genre.movie_id)
, SUM(avg_rating*total_votes)/SUM(total_votes) as actress_avg_rating, dense_rank() 
over (order by SUM(avg_rating*total_votes)/SUM(total_votes)  desc) as actress_rank
from role_mapping join names on role_mapping.name_id=names.id join genre using(movie_id) join
 ratings using(movie_id)
where category ='actress' and avg_rating>8 and genre='drama'
group by name
limit 3;
/*
	name 			total_votes movie_count actress_avg_rating, actress_rank
Sangeetha Bhat			1010		1			9.60000			1
Fatmire Sahiti			3932		1			9.40000			2
Adriana Matoshi			3932		1			9.40000			2

*/
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:








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
*/

WITH temp AS (
    SELECT
        dm.name_id,
        m.date_published,
        LEAD(m.date_published) OVER (PARTITION BY dm.name_id ORDER BY m.date_published) AS next_release_date
    FROM
        movie AS m
    JOIN
        director_mapping AS dm ON m.id = dm.movie_id
    GROUP BY
        dm.name_id, m.date_published
),
not_null_data AS (
    SELECT * FROM temp WHERE next_release_date IS NOT NULL
),
inter_days AS (
    SELECT
        name_id,
        AVG(DATEDIFF(next_release_date, date_published)) AS avg_inter_movie_days
    FROM
        not_null_data
    GROUP BY
        name_id
)


select -- name_id as director_id,
name as director_name,  count(movie_id) as number_of_movies,avg_inter_movie_days ,SUM(avg_rating*total_votes)/SUM(total_votes) as avg_rating,
sum(total_votes) as total_votes, min(avg_rating) as min_rating,
 
max(avg_rating) as max_rating,sum(duration) as total_duration
from names join director_mapping as dm 
	on names.id =dm.name_id 
join movie 	
	on  dm.movie_id=movie.id
join ratings 
	using(movie_id)
join inter_days using(name_id)
group by name_id
order by  count(movie_id) desc
limit 9;
/*
director_id 	director_name, 	number_of_movies, avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration
nm2096009		Andrew Jones			5				190.7500			3.03821	1989			2.7			3.2			432
nm1777967		A.L. Vijay				5				176.7500			5.65382	1754			3.7			6.9			613
nm6356309		Özgür Bakar				4				112.0000			3.95943	1092			3.1			4.9			374
nm2691863		Justin Price			4				315.0000			4.92821	5343			3.0			5.8			346
nm0814469		Sion Sono				4				331.0000			6.30781	2972			5.4			6.4			502
nm0831321		Chris Stokes			4				198.3333			4.31880	3664			4.0			4.6			352
nm0425364		Jesse V. Johnson		4				299.0000			6.09743	14778			4.2			6.5			383
nm0001752		Steven Soderbergh		4				254.3333			6.76933	171684			6.2			7.0			401
nm0515005		Sam Liu					4				260.3333			6.32246	28557			5.8			6.7			312
nm0478713		Jean-Claude La Marre	3				384.5000			2.72641	1280			2.4			4.1			276
nm4899218		Justin Lee				3				180.0000			5.18869	831				3.0			6.7			304
nm2371539		Mainak Bhaumik			3				458.5000			7.01746	882				5.1			7.6			368

*/


/*Format:
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







