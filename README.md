![Cloud Resume Challenge results](/assets/laptop_site.png)

# The Cloud Resume Challenge
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This project starts as an [online resume](https://resume.nlitovchenko.eu/) for [Nikita Litovchenko](https://github.com/litovn). This repo is my attempt at the [The Cloud Resume Challenge (AWS Edition)](https://cloudresumechallenge.dev/docs/the-challenge/aws/) created by [Forrest Brazeal](https://forrestbrazeal.com/).

The project is composed of a [responsive website](front-end), a [Lambda function in Python](lambda), and [Infrastructure as Code with Terraform](terraform).

From the [challenge website](https://cloudresumechallenge.dev/docs/faq/#what-is-the-cloud-resume-challenge):
> The Cloud Resume Challenge is a hands-on project designed to help you bridge the gap from cloud certification to cloud job. It incorporates many skills that real cloud and DevOps engineers use in their daily work.

## Front-End
The front end is developed using S3 to store HTML5, CSS3, and JavaScript files. A domain was obtained through an external domain provider, and a hosted zone was created on Route 53 to configure the DNS used by the domain. After that a certificate was issued by the ACM which was then validated through a CNAME entry, ensuring a secure HTTPS connection between the client and the website, establishing a TLS connection for enhanced security. Route 53 directs internet traffic to a CloudFront distribution which retrieves the files from the S3 bucket and serves them to the client.

## Back-End
For the back end, I used multiple approaches to grasp a better knowledge of the different available tools and because of that, I tried different approaches that got me to the same solution.

Firstly a DynamoDB table was created and populated, then a lambda function was written in Python to track the number of views. To ensure that the lambda function could access the DynamoDB table, I created a relevant role that granted the necessary read and write permissions. 
Even though the challenge asks to create an API, during the creation of the Lambda a function URL could be provided and be utilized to call it without the need of an API. I tried to implement this option and it all worked out, but since the challenge asked to create an API, I removed the function URL in place of an API set up with API Gateway and configured it to forward requests to the Lambda function. 

To ensure security, I updated the CORS settings of the lambda function and set a lower throttling level. Now, whenever the page loads, an AJAX call from the front end triggered the update of the DynamoDB table. The response from this update contained the updated view count, which was then displayed on the UI.
Connecting CloudWatch to the API gave me logs that allowed me to troubleshoot the errors.

## Infrastructure as Code & CI/CD 
To streamline the development and deployment of my cloud resume website, I have implemented an automation process using GitHub Actions such that when you push new website code, the S3 bucket automatically gets updated. 

I delved into using Terraform to provision the necessary infrastructure for the configuration of the API resources. A lot of time was invested in learning this tool, and through the official documentation, the resources were not that difficult to set up. Even though this approach was not executed, I believe provisioning and deploying everything using Terraform would be a better route than the one I took.

## AWS architecture Diagram
![Cloud Resume Challenge results](/assets/arch.png)

## Areas for improvement
- Include some tests to test the Lambda functionalities. 
- Improve API to read and memorize hashed ip, to distinguish repeated visitors. 
- Fully implement the HashiCorp Terraform for future deployment on other cloud providers.

In conclusion, this short journey has been nothing short of incredible, filled with invaluable learning experiences. 
