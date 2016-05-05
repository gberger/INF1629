#!/usr/bin/env lua

-- TITLE: 27. Lazy Rivers
-- AUTHOR: Guilherme Berger <guilherme.berger@gmail.com>
-- DATE: 03/04/2016
-- VERSION: 1.0
-- CONTENT: ~160 lines

-- Número de palavras mais frequentes que desejamos imprimir
TOP = arg[2] or 25


-- Função auxiliar para separar uma string em um array, baseado num separador.
-- PRE: string é a string que se deseja separar
--      sep é o separador que se deseja usar, por exemplo ','
-- POS: Retorna um array cujos elementos são as substrings da string original,
--      separadas pelo separador dado.
function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end


-- Função auxiliar para transformar um array em um set.
-- PRE: array é um array, isso é, uma tabela com índices inteiros.
-- POS: Retorna uma tabela em que as chaves são os valores do array,
--      e os valores são true.
function set(array)
    local s = {}
    for _, l in ipairs(array) do s[l] = true end
    return s
end


-- Função auxiliar para transformar uma tabela em um array de pares..
-- PRE: table é a tabela que desejamos transformar
-- POS: Retorna um array cujos valores são {key, value}, oriundos da table
function table_to_pairs_array(table)
    local array = {}

    for key, value in pairs(table) do
        array[#array + 1] = {key, value}
    end

    return array
end


-- Função que retorna um iterador para os caractéres do arquivo de nome dado
-- PRE: filename é o nome do arquivo que se deseja ler
-- POS: Retorna um iterador, isso é, uma função que pode ser chamada repetidas
--      vezes. Cada vez essa função retornará um caractere, até que o arquivo
--      seja esgotado. Aí, a função retornará nil.
function characters(filename)
    local file = assert(io.open(filename, 'r'))

    return (function()
        return file:read(1)
    end)
end


-- Função que retorna um iterador para as palavras do arquivo de nome dado
-- PRE: filename é o nome do arquivo que se deseja ler
-- POS: Retorna um iterador, isso é, uma função que pode ser chamada repetidas
--      vezes. Cada vez essa função retornará uma palavra, até que o arquivo
--      seja esgotado. Aí, a função retornará nil.
--      As palavras são definidas como strings compostas somente de caracteres
--      alfanuméricos.
function all_words(filename)
    local characters_iterator = characters(filename)

    return (function()
        local start_char = true
        local word = nil
        for character in characters_iterator do
            if start_char == true then
                if character:match("%w") then
                    word = character:lower()
                    start_char = false
                end
            else
                if character:match("%w") then
                    word = word .. character:lower()
                else
                    return word
                end
            end
        end
    end)
end


-- Função que retorna um iterador para as palavras do arquivo de nome dado,
--      filtrando as stop words e as palavras de 1 caractere.
-- PRE: filename é o nome do arquivo que se deseja ler
-- POS: Retorna um iterador, isso é, uma função que pode ser chamada repetidas
--      vezes. Cada vez essa função retornará uma palavra, exceto stop words, 
--      até que o arquivo seja esgotado. Aí, a função retornará nil.
--      As palavras são definidas como strings compostas somente de 2 ou mais 
--      caracteres alfanuméricos, que não sejam iguais a nenhuma stop word.
--      Stop words são as palavras contidas no arquivo stop_words.txt
function non_stop_words(filename)
    local stop_words = set(assert(io.open('stop_words.txt', 'r')):read('*all'):split(','))
    local all_words_iterator = all_words(filename)

    return (function() 
        for word in all_words_iterator do
            if stop_words[word] == nil and word:len() > 1 then
                return word
            end
        end
    end)
end


-- Função que retorna um iterador para os pares {palavra, frequência} obtiados
--      através do processamento do arquivo de nome dado.
-- PRE: filename é o nome do arquivo que se deseja ler
-- POS: Retorna um iterador, isso é, uma função que pode ser chamada repetidas
--      vezes. Cada vez essa função retornará um array de dois elementos,
--      onde o primeiro elemento é a palavra, e o segundo é sua frequência no
--      arquivo de nome dado.
--      As palavras são definidas como strings compostas somente de caracteres
--      alfanuméricos, exceto stop words, que são as palaras contidas no 
--      arquivo stop_words.txt
--      O iterador retorna estes pares em ordem decrescente de frequência.
--      O iterador pára após TOP palavras, que no caso é 25.
function counted_and_sorted(filename)
    local word_freqs = {}
    for word in non_stop_words(filename) do
        if word_freqs[word] == nil then
            word_freqs[word] = 1
        else
            word_freqs[word] = word_freqs[word] + 1
        end
    end

    local word_freqs_pairs = table_to_pairs_array(word_freqs)
    table.sort(word_freqs_pairs, function(a, b) return a[2] > b[2] end)

    i = 1
    return (function()
        if i > TOP then
            return nil
        end

        word_freq_pair = word_freqs_pairs[i]
        word, frequency = word_freq_pair[1], word_freq_pair[2]

        i = i + 1

        return word, frequency
    end)
end


for word, freq in counted_and_sorted(arg[1]) do
    print(word .. ' - ' .. freq)
end
