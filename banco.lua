-- TITLE: banco
-- AUTHOR: Guilherme Berger <guilherme.berger@gmail.com>
-- DATE: 12/04/2016
-- VERSION: 1.0
-- CONTENT: ~150 lines


function generate_account_num(accounts)
  return #accounts + 1
end


function prompt (text)
  print(text)
  return io.read()
end


function io_account_balance(account)
  print('Seu saldo é: ' .. account.balance)
end

function io_account_deposit(account)
  local amount = tonumber(prompt('Valor do depósito: '))
  account.balance = account.balance + amount
  print('Depósito realizado.')
end

function io_account_withdraw(account)
  local amount = tonumber(prompt('Valor do saque: '))
  account.balance = account.balance - amount
  print('Saque realizado.')
end



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

function io_access_account (accounts)
  print()
  print('*** Acessar conta ***')
  local account_num = tonumber(prompt('Numero da conta: ', '*number'))

  local account = accounts[account_num]
  if account ~= nil then
    local pw = prompt('Senha:')

    if account.pw == pw then
      io_account(account)
    else
      print('Senha inválida.')
    end
  else
    print('Conta não existe.')
  end
end


function io_deposit (accounts)
  print()
  print('*** Depositar em conta de terceiro ***')
  local account_num = tonumber(prompt('Numero da conta: '))

  local account = accounts[account_num]
  if account ~= nil then
    local cpf = prompt('CPF do favorecido: ')

    if account.cpf == cpf then
      local amount = tonumber(prompt('Valor do depósito: '))
      account.balance = account.balance + amount
    else
      print('CPF inválido.')
    end
  else
    print('Conta não existe.')
  end
end


function io_new_account(accounts)
  print()
  print('*** Abrir nova conta ***')
  local name = prompt('Nome: ', '*line')
  local cpf = prompt('CPF: ', '*line')
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

function io_menu()
  print('A) Acessar conta')
  print('D) Depositar em conta de terceiro')
  print('N) Abrir nova conta')
  print('X) Sair')
  return prompt('Selecione uma das opções: '):upper()
end


function main()
  math.randomseed(os.time())

  local accounts = {}

  print('Bem-vindo ao LuaBank.')

  while true do
    print()
    print('*** MENU ***')
    local option = io_menu()
    if option == 'A' then
      io_access_account(accounts)
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

main()