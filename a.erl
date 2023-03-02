-module(a).
%====================================================================================================================================================================
% Funciones API
%====================================================================================================================================================================

-export([str/0, listas/0, for/2, mapas/0, records/0, escribir/1, concatenar/1, leer/0, read_write/1, error/1, leerErrorHandling/0, usarMacro/2, main/0, imprimir/2, mensaje/0, interProcessCommunication/0]).
%====================================================================================================================================================================
% Funciones Internas
%====================================================================================================================================================================

str() ->
    %
    %   STRINGS
    %
    io:fwrite("---------------~n"),
    L = "Feeling Every Sunset",
    L1 = "Feeling Every Nightfall",
    A = string:len(L),
    Comp = string:equal(L, L1),
    if Comp ->
        io:fwrite("iguales ~n",[]);
    true ->
        io:fwrite("diferentes maifren ~n", [])
    end,
    io:fwrite("~s~n~w~n",[L,A]),
    % find
    io:fwrite("~s~n", [string:find("asd", "d")]),
    % lowercase uppercase
    io:fwrite("~s~n", [string:lowercase(string:uppercase("Yeah"))]),
    %---------------------- all tailing
    % replace
    io:fwrite("~s~n", [string:replace("asdsas", "s", "POLLO", all)]),
    % split
    io:fwrite("~s~n", [string:split(L, " ", all)]),
    % concat
    io:fwrite("~s~n", [string:concat(string:concat(L, " "), L1)]),
    % chr (devuelve el indice del caracter)
    io:fwrite("~w~n", [string:chr("12345", $3)]),
    io:fwrite("---------------~n").


sum([])->
    0;
sum([H|T])->
    H+sum(T).

listas() ->
    %
    %   Listas
    %
    io:fwrite("---------------~n"),
    Lista = [1,2,3],
    Lista1 = [4,5,6],
    % Añadir un elemento o lista a una lista
    Lista2 = Lista ++ Lista1,
    % Añadir un elemento o lista a una lista    
    io:fwrite("~w~n", [Lista2 -- Lista]),
    io:fwrite("~w -- ~w~n", [hd(Lista), tl(Lista)]),
    % Listas por comprension-------
    Lista3 = [N*100||N<-Lista2, N rem 2 == 0],
    io:fwrite("~w~n", [Lista3]),
    io:fwrite("~w~n", [sum(Lista3)]),
    io:fwrite("---------------~n").

mapas() ->
    %
    %   Maps
    %
    io:fwrite("---------------~n"),
    Persona = #{nombre => "Alberto", apellido => "Boniato"},
    % llaves y valores
    io:fwrite("keys: ~p y valores: ~p \n", [maps:keys(Persona), maps:values(Persona)]),
    % get atriibuto
    io:fwrite("Nombre: ~p\n", [maps:get(nombre, Persona)]),
    % devuelve el record sin el objeto especificado
    io:fwrite("Sin nombre: ~p\n", [maps:remove(nombre, Persona)]),
    % Find llave
    io:fwrite("Existe llave nombre: ~p\n", [maps:find(nombre, Persona)]),
    %añadir llave y valor
    Persona1 = maps:put(direccion, "Cuba maifren", Persona),
    io:fwrite("keys: ~p y valores: ~p \n", [maps:keys(Persona1), maps:values(Persona1)]).

%
%   Records
%
-record(cliente, {name = "", money = 0.00}).
records() ->
    Antonio =  #cliente{name = "Antonio", money = 100.00},
    io:fwrite("~p tiene $ ~p~n", [Antonio#cliente.name, Antonio#cliente.money]).

%
% File I/O
%
escribir(N) ->
    {ok, Archivo} = file:open("test/test.txt", [write]),
    file:write(Archivo, N),
    file:close(Archivo).

concatenar(N) ->
    {ok, Archivo} = file:open("test/test.txt", [append]),
    file:write(Archivo, N).

leer() ->
    {ok, Archivo} = file:open("test/test.txt", [read]),
	Words = file:read(Archivo, 1024 * 1024),
	io:fwrite("~p~n", [Words]).

read_write(N) ->
    {ok, Archivo} = file:open("test/test.txt", [raw, append]),% Raw es Read and Write :)
    NN = N ++ "\n",
    file:write(Archivo, NN),
    {ok, Binario } = file:read_file("test/test.txt"),% Esta funcion es sincrona 
    io:format("~s~n", [Binario]),
    % Escribir esto en otro Archivo
    file:write_file("test/test2.txt", Binario),
    file:close(Archivo).
%
%   Error Handling
%
error(N) ->
	try
		Res = 2 / N,
		io:fwrite("~w~n", [Res])
	catch
		error:badarith ->
			"No Dividir por 0"
	end.

leerErrorHandling() ->
	try
		{ok, Archivo} = file:open("Archivo_que_no_existe.txt", [read]),
		Words = file:read(Archivo, 1024 * 1024),
		io:fwrite("~p\n", [Words])
	catch
		% Esto coge todos los errores
		_:_ ->
			"File Doesn't Exist"
	end.

%
% Macros
%
-define(add(X, Y), X+Y).
-define(concat(X,Y), [X, Y]).

usarMacro(X, Y) ->
    io:fwrite("~p~n", [?add(X,Y)]), % ? es la forma de llamar a tus macros
    io:fwrite("~p~n", [?concat(X,Y)]). 

%
% CONCURRENCIA
%

% Procesos para probar-----
for(Min,Min) -> 
   ok; 
for(Max,Min) -> 
   io:fwrite("Actual : ~p\n", [Max]), 
   for(Max-1,Min). 

get_id(M) ->
	io:fwrite("ID : ~p\n", [M]).

imprimir(_, 0) ->
    io:format("Hecho :) ~n");
imprimir(Val, Veces) ->
    io:format("~s~n", [Val]),
    imprimir(Val, Veces - 1).
%---------------------------


generarProceso() ->
    spawn( fun() -> get_id( [self()] ) end).

generarProcesos(Max, Min) ->
	spawn(fun() -> for(Max, Min) end),
    spawn(a, imprimir, ["Algo", 10]).
    % diferentes formas de usar el spown


%
%   Mensajes a procesos
%

factorial(Int, Acc) when Int > 0 ->
    factorial(Int - 1, Acc * Int);
factorial(0, Acc) ->
    Acc.

factorialWrite(Int, Acc, Archivo) when Int > 0 ->
    io:format(Archivo, "Log actual: ~p~n", [Acc]),
    factorialWrite(Int - 1, Acc * Int, Archivo);
factorialWrite(0, Acc, Archivo) ->
    io:format(Archivo, "Log actual: ~p~n", [Acc]).


mensaje() -> 
    receive
        {factorial, Int} ->
            io:format("El resultado del factorial de ~p es: ~p ~n", [Int, factorial(Int, 1)]),
            mensaje();
        {factorialWrite, Int} ->
            {ok, Archivo} = file:open("test/factorial.txt", write),
            factorialWrite(Int, 1, Archivo),
            io:format("El resultado factorialWriter de ~p es: ~p ~n", [Int, factorial(Int, 1)]),
            file:close(Archivo),
            mensaje();
        Other ->
            io:format("No hay una funcion definida para ~p~n", [Other]),
            mensaje()
        end.
        %% Idproceso = spawn(fun a:mensaje/0).
        %% Idproceso ! {factorial,12}
        %% Idproceso ! {factorialWrite, 21}


main()->
    generarProcesos(10, 1),
    generarProcesos(20, 10),
    generarProceso().
    

%
%   Inter-Process-Communication
%

imprime(Arg) ->
    io:format("~p------~n",[Arg]). 

ipc1() ->
    receive
        {imprime, Str} ->
            imprime(Str),
            ipc1();
        Other ->
            io:fwrite("No existe el comando: ~p~n", [Other])
        end.

lento(Val,_Proc) when Val>0 ->
    lento(Val-1, _Proc);
lento(0,Proc) ->
    Proc ! {imprime, "Proceso Finalizado"}.

interProcessCommunication() ->
    Proc = spawn(fun() -> ipc1() end),
    spawn(fun() ->lento(1000000000, Proc)end). 
