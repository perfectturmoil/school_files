require './extend_array'
require './regression'
require 'gruff'
require './process_dat'


def find_change_points(y_axis, x_axis, number_of_chunks = 5, change_threshold = 1, change_type = :threshold, min_slope = 0.05)
  # Breaks y_axis and x_axis into chunks, finds slope of each chunk.
  # Then compares slopes to determine if that chunk represents
  # a change.
  # Returns an array of the X coordinates at the begining of chunks identified

  raise "not an array" unless y_axis.kind_of?(Array)
  raise "not an array" unless x_axis.kind_of?(Array)

  # Return variable
  slope_change_x_values = []

  chunk_length = (y_axis.length / number_of_chunks).floor

  chunk_slopes= []

  (0..number_of_chunks-1).each do |chunk|
    start_point = chunk_length * chunk
    # don't need end point
    # end_point = chunk_length * chunk + chunk_length - 1

    y_chunk = y_axis.slice(start_point, chunk_length)
    x_chunk = x_axis.slice(start_point, chunk_length)
    
    chunk_regression = ArrayRegression.new(y_chunk, x_chunk)
    chunk_slopes[chunk] = chunk_regression.slope
  end

  # puts chunk_slopes
  # puts "\n\n"
  # from here. Chunk slopes each_index do |slope_index|
  # (actually 1..chunk_slopes.length -1).each do |slope_ index|
  # if chunk_slopes[slope_index] different from chunk_slopes[index-1]
  # maybe incorporate chunk_slopes [index+1] 
  # then its an inflection, and document accordingly. Probably return
  # the X value, maybe the index (may want to pivot the function to 
    # use that rather than the chunk array thing - make it work first
  
  (1..number_of_chunks - 1).each do |chunk|
    next_slope = chunk_slopes[chunk + 1] # Not used yet, might be better than this_chunk
    this_slope = chunk_slopes[chunk]
    prev_slope = chunk_slopes[chunk - 1]

    # I need a better way of calculating change threshold.
    # This way works, sorta - But having a fixed +/- isn't great, it probably needs
    # to be a percent of itself, or something logarithmic. 
    min_prev_slope = nil
    max_prev_slope = nil

    if change_type == :multiplier
      min_prev_slope = [prev_slope - prev_slope * change_threshold , prev_slope + prev_slope * change_threshold].min
      max_prev_slope = [prev_slope - prev_slope * change_threshold , prev_slope + prev_slope * change_threshold].max
    elsif change_type == :threshold
      min_prev_slope = [prev_slope - change_threshold , prev_slope + change_threshold].min
      max_prev_slope = [prev_slope - change_threshold , prev_slope + change_threshold].max
    else # fail out to treating it like a fixed threshold
      min_prev_slope = [prev_slope - change_threshold , prev_slope + change_threshold].min
      max_prev_slope = [prev_slope - change_threshold , prev_slope + change_threshold].max
    end
    puts "min prev: #{min_prev_slope}"
    puts "slope: #{this_slope}"
    puts "max prev: #{max_prev_slope}"
    puts "\n"

    if not this_slope.between?(min_prev_slope, max_prev_slope)
      slope_change_x_values << x_axis[chunk_length * chunk]
    end
  end
  slope_change_x_values
end

# Original test data
# 
#noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
#clean_decline = noisy_decline.rolling_average(3)
#noisy_knee = [10.2, 9.2, 9.4, 8.7, 8.4, 7.9, 6.7, 6.4, 5.6, 5.1, 5.2, 4.7, 3.7, 3.8, 3.8, 4, 4.3, 3.5, 3.5, 3.9, 4, 3.9, 3.7, 3.9, 4.3, 3.9,]
#clean_knee = noisy_knee.rolling_average(3)
# x_axis = (0...26).to_a

threegcnt = [41.8006370608, 43.7274079969, 43.8750648662, 42.682565856, 41.1419921361, 39.974933422, 39.1190007281, 36.473521078, 38.5922590502, 40.819455602, 41.3710141361, 41.2950640138, 42.047125116, 40.225193518, 20.1643778171, 2.8293033678, -14.0726677049, -30.0367331356, -46.8556674875, -43.7789022978, -41.014946929, -35.9172909547, -30.4948843323, -24.7326580949, -21.8050979286, -22.2935056064, -23.64554841, -22.4329655237, -20.8506753784, -17.0570633773, -11.3810081594, -6.8375808269, -6.326088693, -7.5156512558, -9.6617752664, -12.6395926882, -16.8578230876, -22.6475054055, -28.3148607075, -33.3979966141, -35.7224108074, -36.4070866916, -35.4101334207, -34.3367279951, -35.1977729131, -37.6908456556, -41.4737202995, -44.3748131938, -46.4648438092, -47.3475903511, -48.4532232162, -49.3635718569, -50.6423538271, -52.1489992313, -52.5667928543, -53.6901496094, -54.2270251002, -54.8480082989, -53.4965993527, -51.5359397452, -47.748645616, -43.3893985361, -39.6489850186, -35.8563425988, -33.0668816857, -31.840331088, -32.0103654839, -31.1762333043, -31.8912117615, -34.598112477, -37.876276838, -42.4371898204, -46.6276559565, -50.589563334, -54.2794578034, -57.9823127627, -58.8357592355, -53.4987815905, -48.3248487137, -40.7945746094, -33.183962914, -25.7646560099, -31.178239169, -33.0746810656, -35.090842592, -37.2692530945, -39.5385112543, -35.7790921699, -35.935551988, -39.3027273275, -41.2563175306, -38.4043046109, -36.630592306, -33.3093464132, -29.1523591995, -25.5968806997, -25.7206813037, -24.2289575737, -23.8812268, -24.2211832602, -22.5094204482, -24.1207948983, -24.6797908783, -25.0500363, -23.511157712, -23.46687475, -22.5074229997, -23.3569491938, -24.6595630281, -25.1971641518, -26.3655658618, -27.304089836, -27.2857734282, -26.5365499459, -25.70589673, -25.6725272302, -25.55155892, -25.6115209397, -27.8481333777, -28.5567458048, -27.7289849851, -24.0612736508, -19.4603500187, -14.913986741, -13.5329265319, -12.9824203696, -13.9698749419, -15.17290853, -16.4097271059, -15.849712576, -14.1310500219, -14.9944620159, -15.7891394299, -15.6140080757, -15.9235632498, -15.9027213156, -15.2396613657, -16.2781449899, -14.5774391659, -13.8755723979, -14.1997979362, -13.7443551581, -13.071096174, -13.2747225042, -13.012863791, -12.2032236621, -11.1420926504, -11.0689495355, -12.8745969679, -15.8559331108, -19.6350886412, -22.965192407, -25.2498291574, -25.1728953414, -24.9750111684, -22.5361520905, -18.2476005752, -12.4469796989, -7.1097087875, -2.1024287887, 2.6197938785, 7.7614767205, 12.1417916328, 15.0369844303, 15.488007316, 15.7241406731, 12.7684232417, 8.4876122199, 2.305583486, -2.5467571124, -8.6246681031, -15.6760883819, -22.0328385931, -26.0158525158, -27.949935988, -29.0660615623, -27.477503562, -25.4156351302, -23.3726151153, -20.8723752107, -16.4525892895, -12.9383831471, -9.0467644595, -4.9744074382, 0.8603980038, 3.7945420284, 6.3907268357, 9.6417872552, 10.5348805401, 8.0179651827, 6.6838985216, 2.5139360368, -4.2762336168, -10.4816538379, -15.7975001849, -22.6243223071, -26.2464034308, -29.5967818826, -31.0061199501, -32.0008295361, -33.2716293734, -34.2941883601, -33.6719004482, -33.4210078388, -31.0106813945, -28.0429801557, -24.5214389529, -20.1624131616, -17.0220229235, -14.5456456266, -10.0055064417, -6.5801297009, -5.144605428, -2.4872907709, 0.0596371431, -0.4815836962, -1.4409190178, -3.0811231498, -5.014963359, -10.4196604267, -16.132524614, -19.2751323987, -23.6668799475, -27.205290813, -27.6998904373, -25.2744092386, -25.157821802, -22.4769182231, -20.2615083568, -18.2849069059, -17.4709393021, -15.5108547565, -15.3313981734, -15.3882279865, -16.36635473, -19.3019580372, -21.9580751825, -23.1106375724, -23.204535313, -22.8265205033, -21.7878280923, -20.6338948462, -20.220868716, -17.3855386462, -14.9776376318, -9.8977000862, -7.2728823908, -5.2228485912, -7.3571379088, -8.8324238528, -11.6433727603, -15.106766146, -18.8668489415, -21.4149759129, -25.4948430426, -29.6428024516, -32.2877182376, -35.0841483131, -36.874964748, -39.4834526647, -42.2101533771, -42.4739676356, -41.0024835575, -40.8691174842, -39.4570378903, -37.9127688378, -39.3141619831, -41.5915997732, -45.1403872602, -46.0725511726, -47.9962784391, -49.3039154895, -49.1457935125, -48.3572671849, -49.1903684895, -49.2360494196, -48.7303002719, -47.9149751138, -44.9561552454, -43.1967114251, -40.1643076945, -37.5971383616, -37.1853967968, -38.0837408002, -38.1730945181, -40.5044568513, -41.4499485478, -42.0082783241, -42.8901182778, -41.8481653351, -40.720239345, -42.0522991519, -43.5090816453, -44.2852238763, -44.663452692, -44.6071929555, -43.2684423637, -41.8281785503, -41.5407175701, -42.7491491366, -43.7719924092, -46.2859969638, -47.8138123468, -48.7054368299, -50.7705147993, -52.0694689602, -49.3115741644, -46.4078934018, -44.1177506562, -41.3913810302, -39.249545835, -40.5288773689, -40.3152130295, -37.0056285091, -33.9455500286, -31.5709924579, -29.0817777142, -28.1972501643, -29.4977708243, -30.3658976227, -31.8851153992, -33.6366090514, -32.7144511987, -31.8194420174, -30.3002118561, -24.6822382096, -17.2677186649, -13.0532766994, -8.0613109197, -6.5681275949, -7.3408245005, -9.8164719846, -10.6634004772, -14.1865377683, -13.8125198461, -11.4795586623, -9.1024153933, -9.1629380729, -8.0458446667, -8.7594587479, -11.6866268665, -12.0233939413, -12.2363102596, -13.2731156271, -11.5195844125, -11.421734732, -12.1182159174, -8.8613396637, -5.6704074793, -2.5248881426, 1.144188302, 2.8186891459, -0.0822761942, -3.2865539443, -9.3716387395, -15.5317591656, -20.0611431632, -22.4894306373, -21.2487912938, -18.7263302106, -14.4348889869, -12.2178460505, -11.756376297, -13.3830427393, -13.7241070867, -15.448115541, -15.4788234767, -14.4022079781, -13.6398014989, -12.5468531422, -12.5892908145, -14.1653448563, -15.0942257889, -15.9079646889, -17.1195390977, -15.1492056668, -12.0766431268, -8.34602345, -3.9748257317, -2.5636615265, -1.8943084523, -2.9233479448, -4.8664181817, -6.8208822332, -8.0309255946, -10.9228956025, -11.6942092132, -12.411060914, -11.9551697526, -9.6704660781, -6.5428912908, -3.711249575, -1.3494492233, -0.3064441647, 1.5697818022, 1.7901511602, -1.9355091214, -7.8801888362, -17.431613877, -32.0927188091, -46.301364534, -59.6346912861, -72.9954995338, -83.6141114336, -91.2179455269, -94.2784408458, -93.3611884296, -85.0362772781, -73.0079503786, -59.1243119556, -45.139782254, -29.5298755921, -15.812775268, -3.9963952515, 4.3209322378, 9.5558533806, 11.7649532672, 9.8487946354, 6.4181365199, 4.1013981089, 0.7674674924, -3.1218078185, -5.3134029765, -5.8317312919, -5.5974148054, -4.5868478883, -1.4928060144, 4.0218928181, 9.1150035433, 15.4873090535, 21.9666383784, 27.2162202723, 30.9573053721, 33.29494032, 33.9677289549, 35.8149896163, 36.5642230932, 34.4376595236, 32.9968045518, 30.7024655052, 26.6736270048, 22.8161291968, 19.9163289271, 16.864454579, 13.8370484162, 10.7025967777, 10.2598520666, 10.2924516596, 10.0993052501, 10.7667399243, 10.7713804398, 10.0883040141, 8.7253336668, 7.970657441, 7.5772600673, 9.1792327411, 9.1762037553, 10.3393325947, 11.9414396215, 13.6748462081, 13.9966160979, 17.6556944281, 21.5485065706, 25.115013859, 29.5966677736, 36.0177380443, 39.7768858626, 43.9730815332, 48.5668834165, 52.5684473328, 54.654848399, 55.6087414972, 55.1397818837, 54.3628706098, 52.8311767723, 51.3572812457, 49.0372172561, 47.4026164375, 43.3178196136, 39.1533906236, 34.3656084884, 33.9372437198, 32.4384414218, 31.931971819, 33.1357161418, 35.6247948736, 35.093321231, 35.6745866459, 35.5439891052, 32.3853192829, 27.2544655904, 21.0881933715, 16.476287007, 11.3939484522, 7.1020158958, 5.0747903831, 4.1971030861, 2.8598875497, 3.705800654, 7.7100821797, 12.3025857247, 20.0536219373, 26.1307959806, 31.6676286332, 36.5253657442, 39.3486884788, 39.400500096, 38.2070965238, 35.555727347, 29.9682479415, 24.1488598511, 18.8252503399, 14.9972180739, 11.9035979982, 11.5653727435, 12.3654545851, 11.4540423837, 10.9416963603, 13.1825275041, 14.2001722671, 15.9560601685, 19.3364051461, 21.286105115, 21.6587737251, 21.3987753596, 20.0335526723, 19.0156491611, 19.3808049493, 19.0727400057, 20.7117894895, 24.0948120039, 27.3368441883, 31.6873041239, 37.9265025489, 43.0010813631, 46.1549370207, 48.7654114947, 52.3802542783, 57.0426591203, 61.6916941524, 68.6316309266, 76.2423621699, 82.1326617632, 85.911563994, 89.5558312386, 89.1956548482, 88.5550176229, 86.2699398395, 81.3103586413, 76.185646721, 72.1460186537, 65.6828610521, 60.8442267761, 57.798042604, 54.7729691397, 51.8388638698, 50.2593993764, 50.3912627786, 51.0764648322, 52.948036788, 57.1902800106, 64.3650857016, 69.9299401503, 76.4255015947, 81.5850209776, 82.8262310985, 83.3805019446, 83.0484349154, 82.5634833112, 81.9915775545, 83.2940941352, 82.2795420781, 81.3660680197, 79.8638113566, 77.2213818487, 74.9303235132, 73.7087210312, 72.352782562, 68.223595136, 66.3929601531, 63.9159549687, 62.5756275482, 60.5207532123, 61.0351164535, 60.8459436577, 61.7999625068, 62.5055521518, 65.8797252107, 68.6480243471, 71.5192791473, 75.4810208522, 78.1500006173, 78.7402745418, 81.148163116, 82.579542945, 83.2886352938, 84.2884830922, 83.9902152769, 81.6433704637, 81.2939785201, 79.8758653492, 78.7310208008, 78.5585323803, 79.4777431279, 77.9687842157, 76.7085031528, 74.8795368351, 73.9216329094, 72.3326588113, 73.5045169078, 73.3030359101, 72.5362481315, 70.9622386824, 71.4193841252, 68.4239448417, 67.3963493489, 66.7360019621, 64.8309985157, 60.2651530746, 56.3270412967, 51.1014145091, 43.617611745, 37.7683744341, 33.2111930452, 28.7928475548, 27.3713214904, 30.2557960555, 35.0884610757, 41.4854685582, 50.1213447411, 56.6550605655, 62.6264577597, 67.9883182585, 72.9380360041, 74.9446299832, 76.5596976109, 75.4230713222, 71.5082226336, 66.239098905, 62.7230423573, 56.7507542793, 50.1416256867, 46.3452213064, 44.025940384, 40.415978428, 40.5526229914, 42.9102664631, 46.4610244956, 48.6668921929, 53.4029150739, 58.7007784337, 65.7498916112, 72.1833964854, 78.4282348201, 83.9063033778, 87.0650632836, 88.4159110591, 89.3717082631, 92.5812102381, 94.9990075536, 96.6943511356, 99.455510718, 100.7074453603, 99.411560899, 96.4111095291, 95.5058013257, 93.1816761192, 92.5909498904, 91.2815030579, 91.5123110153, 91.1166194811, 89.1536521189, 84.0550352123, 79.338430135, 74.1230500642, 66.6910685778, 60.8453684609, 58.4860142022, 57.5398542389, 58.0519014906, 61.9110533822, 66.3709358871, 68.77370704, 72.0914351366, 74.7099545784, 75.6454560738, 76.5411755722, 78.7840026718, 81.1430576831, 83.1680090129, 87.8446950007, 92.4091685358, 97.054604549, 100.1865236316, 101.4652930964, 100.4694299668, 99.7148084722, 98.6157180309, 97.2928607244, 97.437029589, 98.3600742381, 97.8348981872, 96.6336762123, 95.014786141, 92.2061129529, 85.8610966854, 81.4574617133, 77.1590600561, 73.2329765327, 70.3163774434, 70.2316356398, 68.1863894202, 65.777451716, 62.4535991695, 59.3813957445, 57.4610133562, 56.8522170935, 56.5579518542, 56.8225361228, 57.306170271, 59.1106444247, 61.5837315653, 65.3009942256, 70.3272106905, 74.0458161827, 74.7788870193, 77.0419031329, 77.8591173626, 76.1386398919, 76.7742377289, 77.7571755338, 76.4835893847, 75.5448845148, 77.9014750984, 81.3605130654, 86.2293272346, 90.7240593433, 95.1304760709, 97.8311428051, 96.6063297588, 92.9944645464, 87.6198273819, 80.5066968799, 72.2826067913, 66.1009549931, 62.5639796872, 61.4130155068, 60.5958993435, 60.3210418552, 62.5049114723, 63.8270705089, 66.028483627, 71.6062488437, 81.8850330822, 92.6166622158, 104.7637453977, 115.3773609906, 124.8843704298, 128.32677407, 124.8350099709, 117.6518226787, 110.1880276956, 100.5392087068, 92.0674824864, 87.4476679727, 82.0586398728, 76.6955180246, 70.3956797864, 63.9683762573, 58.3622838382, 55.0103205953, 54.7552629985, 56.7982364722, 62.2603942685, 69.5889969613, 79.1108777177, 85.9628159415, 92.9893586274, 96.6530671511, 98.5118783843, 99.7726138707, 101.3704691656, 101.6067258954, 102.4641680028, 101.8800463099, 99.9288860723, 97.573560245, 95.1179654952, 93.7436488148, 93.6233924665, 95.2665507942, 97.3463049456, 98.8997282892, 100.4255348321, 101.6129180748, 100.4437732726, 97.6733348418, 94.7649905287, 91.3377794769, 88.7148157142, 84.6276565578, 82.3614794664, 81.4761175524, 79.6226454068, 76.7667998701, 76.8888101906, 76.923655976, 78.3794049583, 79.4402542077, 79.725523375, 79.5860909283, 76.2409539659, 70.9692989532, 66.8993364569, 63.2707494121, 58.6084710024, 57.5007154133, 56.5636030111, 57.136914397, 58.4395386077, 59.7125092674, 61.9757248204, 64.4649814013, 65.9144467223, 69.8002533615, 77.0927133188, 84.3704365682, 91.7975338195, 96.6877400234, 101.1534739189, 104.2603020836, 106.257859065, 109.0826731727, 113.124892756, 113.063818438, 110.1925465629, 105.0882262681, 96.822024551, 88.9816040475, 82.5182023108, 75.4529580694, 68.9972707458, 64.8738069348, 63.1874042418, 62.8011002898, 66.1410802968, 71.0300216567, 76.0724813398, 79.317971186, 83.9568574641, 87.7366115972, 90.7456878543, 92.5961287115, 92.9372876659, 89.7162910998, 84.4192487646, 77.2401027277, 72.0943141211, 69.5926742468, 68.4474083632, 67.0465984371, 68.5956218805, 71.2731262982, 72.8097011194, 73.9520109989, 77.6136691187, 79.8325312421, 80.8803419229, 79.9928776085, 80.4929485235, 80.2941003308, 79.2362886235, 76.5994231869, 74.3809104871, 69.8523743659, 64.5588561416, 61.4833485913, 59.3768356185, 58.7440202869, 59.8588483468, 63.3754475769, 65.0139680106, 66.1929505259, 66.517967438, 68.601468524, 69.5207057055, 71.5442448225, 75.383207532, 77.4257770669, 78.1875867724, 77.1658507258, 76.0317804996, 74.0958274107, 73.862797951, 73.6026080515, 74.559314118, 76.6332012441, 75.9897213403, 79.171200797, 82.6660045449, 86.5626283586, 89.7622899454, 96.1208915547, 100.2123510294, 104.8153713062, 108.7394217379, 112.1958988693, 114.2692187339, 114.0881669343, 111.6127439175, 109.2264040742, 106.2776222117, 101.5715189256, 95.4442098983, 88.5224609647, 79.0728482157, 70.683843755, 63.643344067, 62.8928988811, 63.0772709183, 66.051440407, 71.437308611, 75.6212646965, 77.7719971173, 81.3197858464, 84.0749379791, 85.5444716591, 88.4086817667, 90.010242562, 90.4418503065, 90.9503343463, 88.7204037659, 86.1335551169, 84.3255131029, 82.2847637765, 80.6078525331, 81.9826636374, 82.3366743617, 82.0664762788, 79.6190300211, 77.5254816726, 73.3249731433, 70.1034516897, 66.3351118118, 63.8090160962, 61.6517788339, 61.6194595456, 62.3085265715, 64.0233727813, 65.8970541827, 68.6481998563, 71.6360959426, 76.1228265755, 81.6226295725, 89.3253454387, 97.3828578699, 104.5843050756, 109.594450761, 113.9173805576, 115.6708999019, 115.3917078555, 112.8924018208, 109.9248398177, 104.8658535961, 101.0596311826, 97.0912221082, 93.2950782262, 90.058397321, 86.6163017716, 82.8729813453, 83.3199213099, 84.2746808868, 85.5241875283, 88.4222403672, 93.1852980636, 94.4541838624, 94.7746438447, 94.5548097029, 91.5008354668, 85.5320153467, 76.7053136684, 69.3116406631, 60.6465878822, 54.8806012549, 51.5253070071, 50.321783163, 49.6234642368, 51.9381206434, 54.4751668643, 59.5904145718, 65.1325720269, 70.122750511, 75.9134885181, 82.6098448951, 86.5101844855, 91.9731273912, 98.2435518686, 103.1161627054, 106.9264209226, 111.6419350673, 113.2976971295, 115.5718988594, 115.9830299981, 116.848476645, 118.2069140915, 118.6852194291, 117.6387778435, 117.3222428363, 114.9727668628, 109.9209466279, 105.0032228574, 101.3656057011, 98.6621261477, 96.2030747261, 93.2683213301, 93.3871637389, 91.0373433933, 86.9171835963, 83.3665588368, 79.5275390748, 75.5810429808, 73.4043390699, 74.184980201, 76.0164040539, 80.4157572415, 83.6598903485, 86.7477253564, 88.7582821615, 91.6309511185, 93.6268106543, 96.8231258929, 100.0624040265, 102.0328294013, 102.3486610193, 101.5817239139, 98.970518076, 94.7545086138, 91.8618308309, 89.5622890949, 88.3589340605, 89.7607333668, 93.272835451, 96.9611064915, 98.8020498499, 101.3327860966, 101.5142206997, 101.0018924195, 100.871945763, 103.745440628, 103.1911013808, 103.8203708049, 102.6409159835, 99.169922569, 94.9486291755, 93.0455384869, 89.4801262598, 86.7644845992, 85.1329934131, 81.5479611535, 77.3702900492, 74.6905996919, 73.6019082181, 72.3176342469, 72.4714744188, 73.7186439291, 75.3545771822, 76.8236504082, 78.605152908, 80.5076631762, 82.1826742966, 83.4229109041, 83.6585281249, 83.7503267888, 84.7819086973, 85.6265979882, 85.2797469907, 83.9353413407, 84.0040803354, 82.0374027126, 81.0699869219, 82.4120895375, 87.0530907094, 90.3111788001, 94.4968643658, 98.5109241582, 102.9532063846, 104.7613840319, 108.0633031178, 112.0768433221, 115.1234512262, 114.4086845398, 116.9869418021, 117.5595477201, 118.8791615237, 119.8391426895, 122.0974541735, 120.7916242652, 120.8891163439, 117.3342780076, 113.8948857788, 110.1363407236, 105.5770018514, 97.594478761, 91.9848629877, 88.1675683301, 84.8826964788, 81.2310249154, 81.2536306173, 82.0405558631, 81.9066570878, 84.2157276455, 89.4669566866, 92.5531918768, 95.9822801776, 99.0647497319, 100.2967394598, 102.32388817, 106.0356779791, 108.2380400028, 109.6215164829, 109.8103091426, 105.700287148, 99.890561283, 94.3853180032, 89.4757398248, 84.2862683989, 81.433056068, 80.021205068, 80.0172114767, 79.7973190635, 81.0652844753, 81.0848268166, 83.5028305691, 85.6403049894, 89.2273144495, 94.1508807864, 102.5750272278, 109.4580956001, 114.8290891755, 118.2180221856, 119.4836446464, 118.3725363571, 118.2168008137, 117.973025503, 120.4303458031, 123.5715908002, 128.5209639955, 131.2840544421, 137.2952434309, 140.593616157, 143.3653176371, 144.1102029935, 145.8279348016, 143.2122652642, 141.2856643874, 138.1727871202, 134.7869143311, 128.4724479605, 122.0289980542, 114.5444044232, 108.7680737838, 103.2087975327, 100.1083210748, 95.8144983433, 93.8571452487, 92.7438875772, 95.3818823282, 99.0471886806, 106.4240584672, 111.7152371675, 115.9390686337, 117.7310040984, 120.989516788, 124.1532050874, 128.585195481, 131.4547146406, 133.9392032612, 134.1530441765, 134.963008751, 134.3104230475, 136.1097495947, 135.1649370261, 133.4989244267, 126.6802969333, 121.2884155419, 115.6375011224, 112.366987206, 109.5113671657, 107.5187968567, 104.9826385252, 101.4450591479, 98.2362747408, 97.0020181872, 97.2729984663, 97.2634328134, 97.7207989965, 101.2576649882, 104.8592583772, 108.9440177836, 113.7187490374, 118.4271555047, 117.1162869595, 115.0541177172, 111.0707228485, 107.6723304477, 104.5887634125, 104.9625790473, 104.6175055921, 104.2498438608, 102.9603879899, 100.4794643812, 98.8288105503, 96.785985725, 97.9196030784, 100.0880591631, 104.6832216386, 108.62443594, 110.9230273742, 113.2502526775, 115.6307476178, 116.9630851563, 117.3687084515, 121.4444689598, 124.2455753986, 127.4293862112, 131.7336631309, 134.5605508242, 134.5678030442, 131.6992221821, 126.0145784285, 118.2945073854, 113.4942983143, 107.0688258071, 103.964532768, 100.6897955533, 97.0927038815, 91.3442708906, 85.3573847428, 79.8558278337, 77.2015627749, 76.6330791697, 77.0714517824, 80.7865391612, 85.1571531478, 89.2086323071, 92.7639957905, 96.1076693788, 100.2775110696, 102.8580591727, 104.7059155986, 107.7716966815, 111.9111343239, 112.8957836054, 115.0505655155, 116.7667962819, 118.0006752931, 117.5342827197, 117.4635091901, 116.8975516949, 117.0370334197, 112.5466931783, 109.0559526432, 105.5229514863, 102.309845053, 99.7276917681, 100.3536855664, 101.0750543259, 101.735083022, 98.9596487049, 94.502472502, 90.8695608538, 86.6537709747, 85.1705493852, 87.6273029804, 92.8568731539, 98.298035492, 103.9388472874, 108.1185732283, 111.7557299763, 113.9950699359, 117.2256137654, 123.5597937103, 129.5679784827, 137.0872042216, 144.0074817777, 148.5857208356, 149.8458230466, 148.4158220831, 143.687888255, 140.991373717, 138.8692915946, 138.2321238555, 141.0375740111, 143.3327851016, 143.6743787196, 141.391351464, 136.9549250543, 131.1615871429, 127.3407015264, 123.4152834002, 122.0548896231, 120.9883670557, 119.0964912806, 116.7475945055, 112.9616057683, 110.0301119946, 107.9641233105, 106.0258192252, 107.0185849883, 109.9736860875, 111.8002637755, 113.4548581205, 116.1078058787, 115.8020545706, 116.4454797786, 115.1724776614, 114.3084330913, 114.775769845, 114.4833251201, 113.3442622002, 114.9292698745, 116.3080507308, 116.0561797366, 117.5491694629, 119.401653742, 120.3263534226, 122.152438632, 122.5046798579, 124.2984267328, 124.9600011203, 126.6221961882, 127.1425191142, 131.330655076, 134.3779337283, 136.4918084893, 135.8263864454, 136.6601080813, 135.8326633263, 133.5485018466, 133.0155134268, 133.911052347, 131.4620164853, 129.4766821254, 128.3452536833, 126.5194577698, 123.8222521525, 123.3238970041, 123.0887693316, 124.3554131214, 125.8648651186, 130.7107201342, 135.8332794655, 140.9183218099, 142.3974098217, 141.9826409407, 139.7554802299, 136.0443142686, 130.8103588093, 126.5322474487, 124.4138406847, 121.5099738274, 118.7757686526, 118.1362584829, 119.8718033969, 120.0679342128, 120.1077941384, 121.7155645844, 122.4952823292, 120.7969435148, 122.1365574528, 125.7112400711, 127.6034307193, 129.6930116709, 131.7616205465, 131.712976924, 129.3823993463, 127.4525907386, 124.9721039124, 122.8567221295, 122.5235703278, 122.6968842246, 122.0019140784, 122.8384496752, 125.1336493894, 125.9148437448, 129.3508256927, 137.1462306764, 145.5013590578, 157.017482679, 172.6583364371, 190.401334627, 209.2595980536, 231.6459339105, 254.011119061, 276.4973633576, 296.9355789494, 316.519353269, 332.1974946447, 345.6254576892, 358.6688611839, 372.5386285335, 385.6611485656, 399.7509569231, 414.4925723452, 427.6587192666, 440.0964588609, 452.8478407938, 465.3297959607, 479.6145826496, 493.9791677445, 509.0339084778, 521.7282737132, 534.0002868753, 543.3313519344, 550.6092190329, 554.707967744, 560.3028690618, 564.1643301357, 567.725306743, 572.057305159, 577.5009744313, 580.1385507513, 581.2799672574, 581.0324325427, 579.4716559917, 578.161508796, 578.362268069, 580.6066854946, 585.1068261858, 589.2616620302, 592.3961183216, 593.7006925404, 595.2543359555, 595.0246475279, 595.2265874054, 596.1845218696, 598.5186971579, 599.53150489, 599.0414369132, 599.3963756617, 598.5594734348, 595.2751628943, 592.1838828214, 589.076814438, 583.8218601353, 578.9322611224, 575.9791713741, 574.3359565761, 575.260910131, 579.1768280473, 583.583284989, 588.8536484469, 593.8693445303, 598.5456125557, 602.6113883082, 607.154611256, 612.175281398, 617.6733987343, 623.6489632647, 630.1019749891, 636.7141357784, 643.9628928266, ]
threegcnt_x_axis = (1..threegcnt.length).to_a

big_test_data = [9.97, 9.94, 9.91, 9.88, 9.85, 9.82, 9.79, 9.76, 9.73, 9.7, 9.67, 9.64, 9.61, 9.58, 9.55, 9.52, 9.49, 9.46, 9.43, 9.4, 9.37, 9.34, 9.31, 9.28, 9.25, 9.22, 9.19, 9.16, 9.13, 9.1, 9.07, 9.04, 9.01, 8.98, 8.95, 8.92, 8.89, 8.86, 8.83, 8.8, 8.77, 8.74, 8.71, 8.68, 8.65, 8.62, 8.59, 8.56, 8.53, 8.5, 8.47, 8.44, 8.41, 8.38, 8.35, 8.32, 8.29, 8.26, 8.23, 8.2, 8.17, 8.14, 8.11, 8.08, 8.05, 8.02, 7.99, 7.96, 7.93, 7.9, 7.87, 7.84, 7.81, 7.78, 7.75, 7.72, 7.69, 7.66, 7.63, 7.6, 7.57, 7.54, 7.51, 7.48, 7.45, 7.42, 7.39, 7.36, 7.33, 7.3, 7.27, 7.24, 7.21, 7.18, 7.15, 7.12, 7.09, 7.06, 7.03, 7, 6.97, 6.94, 6.91, 6.88, 6.85, 6.82, 6.79, 6.76, 6.73, 6.7, 6.67, 6.64, 6.61, 6.58, 6.55, 6.52, 6.49, 6.46, 6.43, 6.4, 6.37, 6.34, 6.31, 6.28, 6.25, 6.22, 6.19, 6.16, 6.13, 6.1, 6.07, 6.04, 6.01, 5.98, 5.95, 5.92, 5.89, 5.86, 5.83, 5.8, 5.77, 5.74, 5.71, 5.68, 5.65, 5.62, 5.59, 5.56, 5.53, 5.5, 5.47, 5.44, 5.41, 5.38, 5.35, 5.32, 5.29, 5.26, 5.23, 5.2, 5.17, 5.14, 5.11, 5.08, 5.05, 5.02, 4.99, 4.96, 4.93, 4.9, 4.87, 4.84, 4.81, 4.78, 4.75, 4.72, 4.69, 4.66, 4.63, 4.6, 4.57, 4.54, 4.51, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.56, 4.62, 4.68, 4.74, 4.8, 4.86, 4.92, 4.98, 5.04, 5.1, 5.16, 5.22, 5.28, 5.34, 5.4, 5.46, 5.52, 5.58, 5.64, 5.7, 5.76, 5.82, 5.88, 5.94, 6, 6.06, 6.12, 6.18, 6.24, 6.3, 6.36, 6.42, 6.48, 6.54, 6.6, 6.66, 6.72, 6.78, 6.84, 6.9, 6.96, 7.02, 7.08, 7.14, 7.2, 7.26, 7.32, 7.38, 7.44, 7.5, 7.56, 7.62, 7.68, 7.74, 7.8, 7.86, 7.92, 7.98, 8.04, 8.1, 8.16, 8.22, 8.28, 8.34, 8.4, 8.46, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, 8.5, ]
big_test_data_x = (1..big_test_data.length).to_a


data_x, data_y = ProcessDat.process_dat('/home/dan/school/data_files/50ugCNTwithcells.dat')

#cleaned_threegcnt = threegcnt.rolling_average(50)

puts find_change_points(data_y, data_x, 20, 1, :threshold)
puts find_change_points(data_y, data_x, 20, 0.5, :multiplier)

# puts find_change_points(cleaned_threegcnt, threegcnt_x_axis, 20, 1, :threshold)
# puts find_change_points(cleaned_threegcnt, threegcnt_x_axis, 20, 0.5, :multiplier)

# cleaned_data2 = cleaned_data.rolling_average(50)
# cleaned_data3 = cleaned_data2.rolling_average(50)

#puts "Change points in clean knee: 4 chuncks, threshold .2, default change_type"
#puts find_change_points(clean_knee, x_axis, 4, 0.2)


#puts "Change points in clean knee: 4 chuncks, threshold .2, :threshold"
#puts find_change_points(clean_knee, x_axis, 4, 0.2, :threshold)

#puts "Change points in clean knee: 4 chuncks, threshold .2, :multiplier"
#puts find_change_points(clean_knee, x_axis, 4, 0.2, :multiplier)


#puts "Change points in clean knee: 4 chuncks, threshold .5, :multiplier"
# puts find_change_points(big_test_data, big_test_data_x, 20, 0.5, :multiplier)
