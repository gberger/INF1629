-- TITLE: banco
-- AUTHOR: Guilherme Berger <guilherme.berger@gmail.com>
-- DATE: 12/04/2016
-- VERSION: 1.0
-- CONTENT: ~200 lines



-- Função auxiliar para mostrar uma pergunta e ler o input do usuário
-- PRE: o texto a ser exibido está em `text`
-- POS: o texto é exibido, retorna o input do usuário
function prompt (text)
  print(text)
  return io.read()
end


-- Função auxiliar para gerar um número de conta válido
-- PRE: as contas bancárias estão presentes em `accounts`
-- POS: retorna um numero valido de conta bancária não utilizado
function generate_account_num(accounts)
  return #accounts + 1
end


-- Função auxiliar para validar um valor financeiro digitado
-- PRE: um valor numérico (ou nil) será fornecido em `number`
-- POS: se o valor for numérico e maior que zero, retorna true;
--      senão, retorna false
function validate_amount(number)
  if number == nil then
    return false
  elseif number > 0 then
    return true
  else
    return false
  end
end


-- Mostra o saldo da conta dada
-- PRE: a conta bancária em que será consultado o saldo é `account`
-- POS: o saldo da conta aparecerá na tela
function io_account_balance(account)
  print('Seu saldo é: ' .. account.balance)
end


-- Pede o valor do depósito 
-- Realiza o depósito na conta dada, se possível
-- PRE: a conta bancária em que será realizado o depósito é `account`
-- POS: dado que o usuário digita um valor válido e positivo para ser 
--      depositado na conta, o saldo da conta será aumentado de tal valor
function io_account_deposit(account)
  local amount = tonumber(prompt('Valor do depósito: '))

  if not validate_amount(amount) then
    print('Valor inválido ou negativo.')
    return
  end

  account.balance = account.balance + amount
  print('Depósito realizado.')
end


-- Pede o valor do saque
-- Realiza o saque na conta dada, se possível
-- PRE: a conta bancária de que será realizado o saque é `account`
-- PÓS: dado que o usuário digita um valor válido e positivo para ser 
--      sacado da conta, e o saldo seja maior ou igual a esse valor,
--      o saldo da conta será diminuído de tal valor
function io_account_withdraw(account)
  local amount = tonumber(prompt('Valor do saque: '))

  if not validate_amount(amount) then
    print('Valor inválido ou negativo.')
    return
  end

  if amount > account.balance then
    print('Valor superior ao seu saldo. Saque não realizado.')
    return
  end
  
  account.balance = account.balance - amount
  print('Saque realizado.')
end


-- Interage com um usuário, dado a sua conta logada
-- Mostra o menu da conta
-- Chama a função correspondente à opção escolhida
-- O menu se repete até o usuário escolher sair
-- PRE: a conta bancária de que será realizado o saque é `account`
-- PÓS: dependendo das operações realizadas pelo cliente, o saldo
--      da conta pode estar diferente, mas nunca negativo.
--      os outros dados da conta (nome, CPF e senha) não serão alterados
function io_account(account)
  while true do
    print()
    print('>>> Bem-vindo à sua conta, ' .. account.name .. ' <<<')
    print('C) Consultar saldo')
    print('D) Depositar')
    print('S) Sacar')
    print('X) Sair')
    local option = prompt('Selecione uma das opções: '):upper()
    if option == 'C' then
      io_account_balance(account)
    elseif option == 'D' then
      io_account_deposit(account)
    elseif option == 'S' then
      io_account_withdraw(account)
    elseif option == 'X' then
      return
    else
      print('Opção inválida.')
    end
  end
end


-- Pede os dados da conta do usuário
-- Se válido, chama a função de interação com a conta
-- PRE: as contas bancárias estão presentes em `accounts`
-- POS: dado que a conta de número fornecido pelo usuário tem como senha
--      a senha também fornecida pelo usuário, retorna tal conta.
--      senão, retorna nil
function io_access_account (accounts)
  print()
  print('*** Acessar conta ***')
  local account_num = tonumber(prompt('Numero da conta: ', '*number'))

  local account = accounts[account_num]
  if account == nil then
    print('Conta não existe.')
    return
  end

  local pw = prompt('Senha:')
  if account.pw ~= pw then
    print('Senha inválida.')
    return
  end

  io_account(account)
end


-- Pede os dados da conta do favorecido e chama a função de depósito
-- PRE: as contas bancárias estão presentes em `accounts`
-- POS: dado que a conta de número fornecido pelo usuário tem registrado
--      o CPF também fornecido pelo usuário, e dado que o usuário digita
--      um valor válido e positivo para ser depositado na conta, o saldo da
--      conta será aumentado de tal valor
function io_deposit (accounts)
  print()
  print('*** Depositar em conta de terceiro ***')
  local account_num = tonumber(prompt('Numero da conta: '))

  local account = accounts[account_num]
  if account == nil then
    print('Conta não existe.')
    return nil
  end

  local cpf = prompt('CPF do favorecido: ')
  if account.cpf ~= cpf then
    print('CPF inválido.')
    return nil
  end

  return account
end


-- Pede os dados cadastrais ao usuário e registra sua nova conta
-- PRE: as contas bancárias estão presentes em `accounts`
-- POS: uma nova conta bancária, com os dados fornecidos pelo usuário,
--      também estará presente em `accounts`
function io_new_account(accounts)
  print()
  print('*** Abrir nova conta ***')
  local name = prompt('Nome: ')
  local cpf = prompt('CPF: ')
  local pw = prompt('Escolha uma senha: ')
  local account_num = generate_account_num(accounts)

  print('O número da sua nova conta é: ' .. account_num)

  accounts[account_num] = {
    name = name,
    cpf = cpf,
    pw = pw,
    balance = 0
  }
end


-- Função principal
-- Inicializa a tabela de contas
-- Mostra as opções e lê a escolhida
-- Chama a função correspondente à opção escolhida
-- O menu se repete até o usuário escolher sair
function main()
  local accounts = {}

  print('Bem-vindo ao LuaBank.')

  while true do
    print()
    print('*** MENU ***')
    print('A) Acessar conta')
    print('D) Depositar em conta de terceiro')
    print('N) Abrir nova conta')
    print('X) Sair')
    local option = prompt('Selecione uma das opções: '):upper()
    if option == 'A' then
      local account = io_access_account(accounts)
      if account then
        io_account(account)
      end
    elseif option == 'D' then
      io_deposit(accounts)
    elseif option == 'N' then
      io_new_account(accounts)
    elseif option == 'X' then
      return
    else
      print('Opção inválida.')
    end
  end
end

-- inicia a aplicação
main()