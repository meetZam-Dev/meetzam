# meetZam Product Overview

	 	 						
### Problem Statement 

Has anyone ever found any difficulty finding the correct movie and the ideal company to watch a movie with? Oftentimes, just the process of finding the right movie and organizing it with the right people can be a time-consuming task.

Here at meetZam, we envision a mobile application that allows individuals to search for other people to go to a movie with. Users can select one or more movies that they want to watch and we will match them with a group of people sharing the same interests. 

### Background Info	
					
##### Targeted Users 
		
We noticed a gap in the market for individuals who have difficulty finding the ideal movie to watch. Even after deciding on a movie, finding the ideal company can prove to be an uphill task as well.
					
##### Similar Platforms 
	
There are a couple of movie apps currently available on the App Store, such as Movies by Flixster and Fandango Movies. They provide similar functionalities such as showtime information, commenting and reviewing, online ticketing and detailed movie information.  

##### Limitations 

While both of the apps mentioned above have proven to be useful, they both lack the ability to help people find their movie-buddies. We believe that one of the major factor that hinders people from going to the movies is the fact that they can’t find other people to go with in a timely manner. 

We aim to address the problem by creating a mobile application that not only provides movie showtimes, commenting and reviewing, but also offers a matching mechanism that groups people based on what movies they want to watch.
			
##### Architecture 
					
We’ve decided to develop the application on the iOS platform targeting iPhone users under several considerations, such as operating system performance, stability, security, and platform popularity. One highlight of our application architecture is that we’re building a No-Server backend, or so-called Serverless Architecture. 

The idea is that we will break our backend functionalities and logics into many small pieces that each serve as an individual cloud-based micro-service that performs some simple tasks. This approach solves many problems that arises from a traditional server-based architecture such as network and server management, compatibility and dependency management, scalability problems, and inefficient use of resources. In addition, since many application backends share common functionalities, breaking them into individual micro-services increases code reusability significantly. 

##### Framework and Tools

We will utilize Serverless Framework to help configure, provision and deploy Lambda functions onto AWS services. These Lambda functions respond to events, and can be triggered by our mobile app using AWS Mobile SDK or HTTP(s) requests via a custom API hosted on AWS API Gateway. Once triggered, the Lambda functions will perform tasks suitable to support the functional needs of our application, such as data processing, user authentication, communicate with database, file system, and external APIs. 

Client side logics will be written in Swift and uses Xcode as the primary development environment. Lambda functions will be written in JavaScript using Node.js 4.3 runtime. User authentication will support 3rd-party authentication providers such as Facebook, Google, and Amazon. In-app push notification will be done using Amazon Pinpoint, while email notification will be done using AWS SNS. 

##### Security

One advantage of building backend on a matured platform like AWS is security. AWS services come with several security feathers out of the box. AWS IAM is a permission management service that enable us to assign appropriate permissions to different user groups, and admin groups to make sure no surprise will hit our face from the ground up. In addition, user authentication and other user activities will be filtered, monitored, and reported through Amazon Cognito so that things could fly smoothly and securely.  

##### Usability

Our users are very important to us, because everything eventually comes down to if users like the product or not. Thus user experience will be a driven factor of our UI/UX design process. We try to make things easy for our users from the very beginning by allowing only 3rd-party authentication to free our users from memorizing yet another password and the frustrating process of entering the password. Once logged in, it is easy to navigate through and understand the functionality of our app via a thoughtful, intuitive user interface. 

In addition, we require essentially no input from our users to minimize the initial setup process so that a new user can start to enjoy the exciting service we aimed to provide right away. Furthermore, by utilizing both in-app and email notification mechanism, we can provide our users with their matching status in real time to make sure everyone gets notified as soon as we match our user with a group. Combining with an in-app group chat room, our users will be able to have more detailed discussions and plan an outing with their new movie buddies. 

##### Protecting Our Users

We have reimagined the reviewing and commenting process because we understand the importance of reviewing and commenting and how they can be abused by hostile users which leads to a significant drawback in the experience for other users. And finally, to make sure our users have enjoyable experiences, we think beyond the scope of just the application by providing a user rating mechanism as a method encouraging proper social conduct during group movie sessions.


