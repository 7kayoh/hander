local configuration = {}

configuration.groupId = 1 -- use number
configuration.ranks = {} -- >rank, <rank, rank
configuration.pattern = "([<>]?)(%d+)" -- to check pattern of ranks

configuration.maxRetries = 3 -- keep it at a reasonable amount

return configuration