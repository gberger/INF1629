#!/usr/bin/env lua

-- TITLE: 7. Infinite Mirrors
-- AUTHOR: Guilherme Berger <guilherme.berger@gmail.com>
-- DATE: 02/04/2016
-- VERSION: 1.0
-- CONTENT: ~150 lines

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


-- Função para contar as ocorrências de cada palavra, recursivamente
-- PRE: word_array é o array de palavras do texto, já normalizadas em lowercase
--      stopwords é o conjunto, gerado pela função set, de palavras que não
--          devem ser consideradas no resultado final
--      wordfreqs é a tabela que irá guardar o resultado
--      i é o elemento do array que será processado nessa chamada de função
-- POS: A palavra de posição i terá sua frequência incrementada em wordfreqs.
--      A função será chamada novamente com o próximo i, que será inicializado
--          em 1 caso seja nil.
--      A função pára quando chega-se ao final de word_array.
function count(word_array, stopwords, wordfreqs, i)
    if i == nil then
        i = 1
    end

    if #word_array + 1 == i then
        return
    else
        word = word_array[i]
        if stopwords[word] == nil then
            if wordfreqs[word] == nil then
                wordfreqs[word] = 1
            else
                wordfreqs[word] = wordfreqs[word] + 1
            end
        end
        return count(word_array, stopwords, wordfreqs, i+1)
    end
end


-- Função para transformar uma tabela em um array de pares, recursivamente.
-- PRE: table é a tabela que desejamos transformar
--      iterator é a função iteradora obtida a partir de pairs(table),
--          podendo ser nil na primeira chamada
--      prev_key é a chave usada na chamada anterior, ou nil, na 1a chamada
--      array é o resultado, podendo ser nil ou {} na 1a chamada
-- POS: A função iterator será chamada com (table, prev_key) como argumento.
--      O resultado dessa chamada será guardado como elemento no array.
--      A função será chamada novamente com a key dessa chamada de iterator.
--      A função pára quando chega-se ao final do array, isso é, iterator
--          retorna nil.
function table_to_pairs_array(table, iterator, prev_key, array)
    if iterator == nil then
        iterator = pairs(table)
    end

    if array == nil then
        array = {}
    end

    key, value = iterator(table, prev_key)
    if key == nil then
        return array
    else
        array[#array + 1] = {key, value}
        return table_to_pairs_array(table, iterator, key, array)
    end
end


-- Função para imprimir as frequências, recursivamente.
-- PRE: wordfreqs é um array cujos valores são arrays de dois elementos,
--          onde o primeiro elemento é a palavra e o segundo é sua frequência.
--          O array está ordenado em ordem decrescente de frequência.
--      i é o elemento que será impresso na tela nesta chamada de função.
-- POS: A palavra de posição i será impressa na tela, assim como sua frequência
--      A função será chamada novamente com o próximo i.
--      A função para quando chega-se ao final do array, ou depois de imprimir
--          `TOP` elementos (no caso, 25).
function wf_print(wordfreqs, i)
    if i == nil then
        i = 1
    end

    if #wordfreqs + 1 == i or i == TOP + 1 then
        return
    else
        wordfreq = wordfreqs[i]
        word, freq = wordfreq[1], wordfreq[2]
        print(word .. ' - ' .. freq)
        return wf_print(wordfreqs, i+1) 
    end
end


-- Lemos o arquivo contendo as palavras, separando por vírgula e transformando em set.
local stop_words = set(assert(io.open('stop_words.txt', 'r')):read('*all'):split(','))

-- Inicializamos o array das palavras do texto.
local words = {}

-- Lemos o texto do arquivo dado.
local text = assert(io.open(arg[1], 'r')):read('*all'):lower()

-- Adicionamos cada palavra do arquivo ao array.
for word in text:gmatch('%w%w+') do
    words[#words + 1] = word
end

-- Inicializamos a tabela de frequências.
local word_freqs = {}

-- Chamamos a função recursiva count para contar as frequências
-- e guardá-las em word_freqs.
count(words, stop_words, word_freqs)

-- Transformamos a tabela palavra:frequência em uma lista 
-- de pares {palavra, frequência} usando essa função recursiva
word_freqs_pairs = table_to_pairs_array(word_freqs)

-- Ordenamos os pares, usando uma função anônima que usa o segundo elemento
-- do par como chave de ordenação, isso é, a frequência.
table.sort(word_freqs_pairs, function(a, b) return a[2] > b[2] end)

-- Imprimimos usando essa função recursiva
wf_print(word_freqs_pairs)
