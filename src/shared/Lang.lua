-- Lang module provides a number of language-based utilities for the formatting of text based on da rulez of prpr geramer
-- Written for realtime GUI swaps. Really lazy.

local Lang = {}

-- Given a word, this will add "s" to the end if count is not 1.
function Lang:WordToPlural(word, count)
	if count == 1 then
		return word
	end
	return word .. "s"
end

-- Given a word that may or may not start with a vowel, this will return "an" or "a" respectively.
function Lang:GetAForm(nextWord)
	local start = nextWord:sub(1, 1):lower()
	if start == 'a' or start == 'e' or start == 'i' or start == 'o' or start == 'u' or start == 'y' then
		return "an"
	end
	return "a"
end

return Lang