provider "aws" {
  region = "us-east-1"
}

module "lambda" {
  source = "./lambda"
}

module "sns" {
  source     = "./sns-topic"
  lambda_arn = module.lambda.lambda_arn

  sns_subscriptions = {
    "lambda_subscription" ={
        protocol = "lambda"
      endpoint = module.lambda.lambda_arn
    },
    "email_subscription" ={
        protocol = "email"
      endpoint = "rishitzaveri80@gmail.com"
    }

  }

}

module "eventbridge" {
  source = "./eventbridge"
  sns_arn = module.sns.sns_arn
}
