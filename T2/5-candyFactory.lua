#!/usr/bin/env lua

-- TITLE: 5. Candy Factory
-- AUTHOR: Bernardo Alkmim <bpalkmim@gmail.com>
-- DATE: 02/05/2016
-- VERSION: 1.0
-- CONTENT: 126 linhas

-- Número de palavas mais frequentes que desejamos imprimir
TOP = arg[2] or 25

-- Função que lê um arquivo de entrada e retorna seu conteúdo num string.
-- PRE: O arquivo está presente no sistema de diretórios.
-- POS: O arquivo foi lido com sucesso e seu conteúdo foi retornado.
function read_file(path_to_file)
	local f = assert(io.open(path_to_file, 'r'))
	local data = f:read('*all')
	f:close()
	return data
end

-- Função que recebe uma string e retorna uma cópia com todos os caracteres
-- não alfanuméricos substituídos por um espaço em branco cada.
-- PRE: A string recebida por patâmetro representa o conteúdo de um arquivo e é não
-- vazia.
-- POS: A string recebida de entrada foi reformatada com sucesso.
function filter_chars_and_normalize(str_data)
	local pattern = "[^%w\-]+"
	return str_data:gsub(pattern, ' '):lower()
end

-- Função auxiliar que separa uma string num array, baseado num separador.
-- PRE: A input é o separador
-- POS: Retorna um array cujos elementos são as substrings da recebida por parâmetro,
-- tendo em vista o separador dado.
function string:split(sep)
	local fields = {}
	local pattern = string.format("[^%s\-]+", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

-- Função que recebe uma string e busca por palavras, retornando uma tabela com as
-- palavras encontradas.
-- PRE: A string recebida está formatada para ter apenas palavras em lowercase e
-- separadas por espaços.
-- POS: A tabela indexada pelas paravras foi criada.
function scan(str_data)
	return str_data:split(' ')
end

-- Função auxiliar para saber se um value está numa table.
-- PRE: O valor e a tabela são válidos.
-- POS: Retorna true ou false caso o valor esteja ou não.
function value_in_table(val, tab)
	for _, v in pairs(tab) do
		if v == val then
			return true
		end
	end

	return false
end

-- Função que retira as stop words de uma tabela de palavras.
-- PRE: Recebe uma tabela indexada por palavras.
-- POS: Retorna uma cópia da entrada com as stop words removidas.
function remove_stop_words(word_list)
	local non_stop = {}
	local stop_words = assert(io.open("stop_words.txt", 'r')):read('*all'):lower():split(',')

	for i=97,97+25 do
		stop_words[i + #stop_words] = string.char(i)
	end

	for _, word in pairs(word_list) do
		if not value_in_table(word, stop_words) then
			table.insert(non_stop, word)
		end
	end
	return non_stop
end

-- Função que recebe uma tabela de palavras e retorna um dicionário associando
-- palavras com suas frequências de ocorrência.
-- PRE: A tabela recebida têm as palavras a seren contadas.
-- POS: As palavras agora têm suas respectivas ordens de ocorrência.
function frequencies(word_list)
	local word_freqs = {}
	local word_freq = {}

	for _, word in pairs(word_list) do
		if word_freqs[word] then
			word_freqs[word] = word_freqs[word] + 1
		else
			word_freqs[word] = 1
		end
	end

	for word, freq in pairs(word_freqs) do
		local pair = {word = word, freq = freq}
		table.insert(word_freq, pair)
	end

	return word_freq
end

-- Função que recebe um dicionário de palavras e suas frequências e retorna um
-- dicionário de pares ordenados pela frequência.
-- PRE: O input é um dicionário que apresenta palavras e suas frequências, em
-- qualquer ordem.
-- POS: O dicionário está ordenado pela frequência.
function sort(word_freq)
	table.sort(word_freq, function(a, b) return a.freq > b.freq end)
	return word_freq
end

-- Função que recebe um dicionário de pares em que as estradas estão ordenadas
-- por frequência e as imprime.
-- PRE: O dicionário de pares tem as palavras ordenadas pela frequência e o índice
-- da recursção.
-- POS: Terão sido impressos na tela as palavras e os suas frequências.
function print_all(word_freqs)
    local i = 1
    
    for _, w in ipairs(word_freqs) do
    	if i == TOP then
    		break
    	end
    	print(w.word .. " - " .. w.freq)
    	i = i + 1
    end
end

print_all(sort(frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file(arg[1])))))))