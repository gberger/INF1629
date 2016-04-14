-- TITLE: banco
-- AUTHOR: Guilherme Berger <guilherme.berger@gmail.com>
-- DATE: 12/04/2016
-- VERSION: 1.0
-- CONTENT: ~200 lines



-- Função auxiliar para mostrar uma pergunta e ler o input do usuário
function prompt (text)
  print(text)
  return io.read()
end


-- Função auxiliar para gerar um número de conta válido
function generate_account_num(accounts)
  return #accounts + 1
end


-- Mostra o saldo da conta dada
function io_account_balance(account)
  print('Seu saldo é: ' .. account.balance)
end

-- Pede o valor do depósito de um usuário em sua própria conta
-- Realiza o depósito, se possível
function io_account_deposit(account)
  local amount = tonumber(prompt('Valor do depósito: '))

  if amount is nil then
    print('O valor deve ser numérico.')
  elseif amount > 0 then
    account.balance = account.balance + amount
    print('Depósito realizado.')
  else
    print('O valor deve ser positivo.')
  end
end


-- Pede o valor do saque de um usuário em sua própria conta
-- Realiza o saque, se possível
function io_account_withdraw(account)
  local amount = tonumber(prompt('Valor do saque: '))

  if amount is nil then
    print('O valor deve ser numérico.')
  elseif amount > 0 then
    account.balance = account.balance - amount
    print('Saque realizado.')
  else
    print('O valor deve ser positivo.')
  end
end


-- Interage com um usuário, dado a sua conta logada
-- Mostra o menu da conta
-- Chama a função correspondente à opção escolhida
-- O menu se repete até o usuário escolher sair
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


-- Pede os dados da conta do favorecido
-- Se válido, pede o valor do depósito
-- Se válido, realiza o depósito
function io_deposit (accounts)
  print()
  print('*** Depositar em conta de terceiro ***')
  local account_num = tonumber(prompt('Numero da conta: '))

  local account = accounts[account_num]
  if account ~= nil then
    local cpf = prompt('CPF do favorecido: ')

    if account.cpf == cpf then
      local amount = tonumber(prompt('Valor do depósito: '))
      if amount is nil then
        print('O valor deve ser numérico.')
      elseif amount > 0 then
        account.balance = account.balance + amount
        print('Depósito realizado.')
      else
        print('O valor deve ser positivo.')
      end
    else
      print('CPF inválido.')
    end
  else
    print('Conta não existe.')
  end
end


-- Pede os dados cadastrais ao usuário e registra sua nova conta
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
  math.randomseed(os.time())

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

-- inicia a aplicação
main()