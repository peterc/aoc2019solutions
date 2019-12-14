# THIS WAS HORRIBLE TO DO, WORST SO FAR :-D

reactions = %{10 LSZLT, 29 XQJK => 4 BMRQJ
    22 HCKS => 1 GQKCZ
    1 HCKS, 8 WZWRV, 18 HVZR => 7 BGFR
    1 LSZLT, 1 WRKJ, 3 LJFP, 3 RNLPB, 1 NZGK, 3 LDSV, 5 RJDN, 8 HGFGC => 3 QZTXD
    1 BRSGQ, 1 XGLF, 1 ZHSK, 20 LSZLT, 16 WFCPT, 3 KTWV, 1 QRJC => 4 XPKX
    1 DCLR, 6 RNLPB => 5 HCKS
    1 HFHFV => 3 SHLMF
    2 LTMZQ, 21 FGCXN => 6 QKFKV
    3 BGFR => 7 WRKJ
    3 KHSB => 2 XQJL
    3 SHLMF => 2 LPLG
    12 SVHWT, 20 BXPSZ => 9 NBMF
    2 FGCXN, 32 DCSVN => 8 TBDWZ
    1 KHSB, 3 HGFGC => 6 WZWRV
    27 WFCPT, 4 KTWV, 14 BRSGQ, 1 MFNK, 1 WRKJ, 2 NZGK, 24 FBFLK => 5 TRLCK
    2 SVHWT => 3 QRJC
    1 MNVR, 1 FKBMW => 2 FGCXN
    4 GJXW => 9 JXFS
    3 XQJK => 5 WNJM
    1 WZVWZ, 1 XQJL => 9 SHKJV
    2 DCSVN => 4 HDVC
    2 GJXW => 2 RNLPB
    1 QKFKV, 1 PBRWB => 5 WTZQ
    14 QKFKV => 6 RDFTD
    166 ORE => 1 QDSXV
    2 DCSVN => 5 BXPSZ
    113 ORE => 6 LTMZQ
    13 MNVR => 7 RJDN
    2 NZGK, 9 XQJK, 18 WRKJ => 9 KTWV
    1 NZGK => 8 XQJK
    6 RZCGN, 6 HDVC, 1 DLKR => 9 DSLXW
    18 HVZR => 8 LJFP
    7 XQJL => 1 NPDS
    15 DLKR, 1 DSLXW, 26 MJFVP => 3 FBFLK
    125 ORE => 9 MNVR
    3 RJDN => 4 HFHFV
    1 TBDWZ, 1 DCLR => 2 HVZR
    2 SHKJV => 5 GJXW
    7 LTMZQ, 1 QDSXV, 1 FKBMW => 3 DCSVN
    9 LPLG, 11 JXFS => 3 BRSGQ
    5 JXFS, 1 ZHSK, 25 XGLF => 4 MFNK
    5 PBRWB => 2 SVHWT
    15 SHKJV => 5 XGLF
    1 XQJL, 2 NPDS => 4 DLKR
    39 JXFS => 5 KSHF
    6 GJXW, 1 FBFLK => 7 HGFGC
    3 JXFS => 1 LSZLT
    3 NBMF, 1 BMRQJ => 2 LDSV
    1 JXFS, 25 GJXW, 10 HGFGC => 4 NZGK
    8 QZTXD, 26 KSHF, 60 WNJM, 6 GJXW, 9 TRLCK, 20 XPKX, 21 FGCXN, 57 GQKCZ, 6 WRKJ => 1 FUEL
    4 SVHWT, 1 RZCGN => 3 ZHSK
    1 BXPSZ => 7 DCLR
    8 RDFTD, 1 SHKJV, 1 HFHFV => 6 MJFVP
    1 LTMZQ => 9 KHSB
    5 WTZQ, 4 HGFGC, 4 HCKS => 9 WFCPT
    184 ORE => 4 FKBMW
    4 XQJL => 3 WZVWZ
    12 QDSXV => 9 RZCGN
    1 FBFLK, 7 HVZR => 9 PBRWB}


els = {}

class El < Struct.new(:name, :qty, :parents)
end

# Turn reactions list into a data structure
reactions.split("\n").map do |reaction|
  srcs, dest = reaction.strip.split(' => ', 2)
  srcs = srcs.split(', ').map { |src| src.split(' ') }
  dest = dest.split(' ')
  srcs.map! { |src| El.new(src[1], src[0].to_i, []) }
  el_qty, el_name = dest
  els[el_name] = El.new(el_name, el_qty.to_i, srcs)
end


# Start the shopping list as 1 x FUEL
shopping_list = [['FUEL', 1]]
remainders = {}

loop do
  new_list = []
  shopping_list.each do |(el_name, el_qty)|
    # puts "Ordering #{el_name} #{el_qty}"

    if remainders[el_name].to_i > 0
      take_away = [el_qty, remainders[el_name]].min
      remainders[el_name] -= take_away
      el_qty -= take_away
    end

    if el_name == 'ORE'
      new_list += [[el_name, el_qty]]
    else
      ael = els[el_name]
      bel_needed = (el_qty.to_f / ael.qty).ceil
      remainder = (bel_needed * ael.qty) - (el_qty)
      #end
      remainders[ael.name] ||= 0
      remainders[ael.name] += remainder

      new_list += ael.parents.map do |bel|
        # el_name, el_qty is what's being ordered
        # ael.name, ael.qty is what's on offer
        # bel.name, bel.qty is what you get for ael
        total_bel = bel_needed * bel.qty
        [bel.name, total_bel]
      end    
    end
  end

  new_list = new_list.group_by { |(a, b)| a }.map { |a, b| [a, b.inject(0) { |c, d| c += d[1] }] }

  shopping_list = new_list
  new_list = []

  break if shopping_list.all? { |(el_name, el_qty)| el_name == 'ORE' }
end

p shopping_list.inject(0) { |a, b| a + b[1] }