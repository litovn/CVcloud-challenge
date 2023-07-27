resource "aws_dynamodb_table" "stats_db" {
  name           = "cloudcv-views"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "add_item_dynamodb" {
  table_name = aws_dynamodb_table.stats_db.name
  hash_key   = aws_dynamodb_table.stats_db.hash_key

  item = <<ITEM
{

  "visitorCount": {"S": "0"},
  "visitors": {"N": "1"}
}
ITEM
  lifecycle {
    ignore_changes = all
  }
}