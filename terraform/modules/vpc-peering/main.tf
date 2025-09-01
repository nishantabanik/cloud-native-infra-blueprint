resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_owner_id = var.accepter_account_id
  peer_region   = var.accepter_region_id
  auto_accept   = true

  tags = merge(var.tags, {
    Name        = var.peering_name
    Environment = var.environment_tag
  })

  provider = aws.default
}

# Route from Requester (Compute) to Accepter (Data) — Single RT
resource "aws_route" "requester_to_accepter" {
  count                     = var.enabled ? 1 : 0
  route_table_id            = var.requester_vpc_rt_id[0]
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  provider                  = aws.default
}

# Routes from Accepter (Data) to Requester (Compute) — Multiple RTs
resource "aws_route" "accepter_to_requester" {
  count                     = var.accepter_private_rt_count * (var.enabled ? 1 : 0)
  route_table_id            = var.accepter_vpc_private_rt_ids[count.index]
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
