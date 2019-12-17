input = "59773419794631560412886746550049210714854107066028081032096591759575145680294995770741204955183395640103527371801225795364363411455113236683168088750631442993123053909358252440339859092431844641600092736006758954422097244486920945182483159023820538645717611051770509314159895220529097322723261391627686997403783043710213655074108451646685558064317469095295303320622883691266307865809481566214524686422834824930414730886697237161697731339757655485312568793531202988525963494119232351266908405705634244498096660057021101738706453735025060225814133166491989584616948876879383198021336484629381888934600383957019607807995278899293254143523702000576897358" * 10000
input = input[input[0,7].to_i..-1].chars.map(&:to_i)

100.times do
  (input.length - 2).downto(0) do |i|
    input[i] = (input[i] + input[i + 1]) % 10
  end
end

p input.first(8).join